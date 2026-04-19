local M = {}

M.config = {
    FMP7_CLI_PATH = nil,

    fmp7_path = nil,
    fadeout_before_play = true,

    play_roots = {},
}

function M.setup(user_config)
    M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

    if vim.fn.has("win32") == 0 and vim.fn.has("win64") == 0 then
        return
    end

    if not M.config.FMP7_CLI_PATH or M.config.FMP7_CLI_PATH == "" then
        vim.notify("FMP.nvim: FMP7_CLI_PATH is not set", vim.log.levels.ERROR)
        return
    end

    M.define_commands()
end

function M.complete(arglead, cmdline, _)
    local parts = vim.split(cmdline, "%s+", { trimempty = true })
    local subcmdlist = { "play", "stop", "pause", "fade" }
    if M.config.fmp7_path and M.config.fmp7_path ~= "" then
        table.insert(subcmdlist, "boot")
    end

    if #parts <= 1 then
        return subcmdlist
    end

    local sub = parts[2]

    if #parts == 2 and arglead ~= "" then
        return vim.tbl_filter(function(v)
            return v:find("^" .. arglead)
        end, subcmdlist)
    end

    if sub == "play" then
        local exts = M._get_supported_exts()

        local function scan(base)
            local result = {}
            local query = (base or "") .. arglead

            local paths = vim.fn.glob(query .. "*", true, true)
            for _, p in ipairs(paths) do
                if vim.fn.isdirectory(p) == 1 then
                    table.insert(result, p)
                else
                    local ext = p:match("%.([^.]+)$")
                    if ext and exts[ext:lower()] then
                        table.insert(result, p)
                    end
                end
            end

            return result
        end

        if arglead == "" then
            local result = {}
            for _, root in ipairs(M.config.play_roots or {}) do
                local normalized = root:gsub("[/\\]+$", "") .. "/"
                vim.list_extend(result, scan(normalized))
            end
            return result
        end

        return scan("")
    end

    if sub == "fade" then
        return { "1", "3", "5", "10", "30", "60" }
    end

    return {}
end

function M.define_commands()
    vim.api.nvim_create_user_command("FMP", function(command)
        M.FMP(command.args)
    end, {
    nargs = "+",
    complete = function(arglead, cmdline, cursorpos)
        return M.complete(arglead, cmdline, cursorpos)
    end,
})
end

function M._run(args)
    local function run_main()
        local cmd = { M.config.FMP7_CLI_PATH }
        vim.list_extend(cmd, args)

        vim.system(cmd, { text = true }, function(obj)
            vim.schedule(function()
                local output = (obj.stdout or "") .. (obj.stderr or "")
                output = output:gsub("%s+$", "")

                if output == "" then
                    if obj.code ~= 0 then
                        vim.notify("FMP7CLI exited with code: " .. obj.code, vim.log.levels.ERROR)
                    else
                        vim.notify(table.concat(args, " "), vim.log.levels.INFO)
                    end
                    return
                end

                if output:match("^ERROR:%s*") then
                    vim.notify(output, vim.log.levels.ERROR)
                else
                    vim.notify(output, vim.log.levels.INFO)
                end
            end)
        end)
    end

    if args[1] == "play" then
        local path = M.config.FMP7_CLI_PATH
        local exe = path and path:match("([^\\/]+)$")

        if exe then
            vim.system({ "taskkill", "/IM", exe, "/F" }, {}, function()
                vim.defer_fn(function()
                    run_main()
                end, 50)
            end)
            return
        end
    end

    if args[1] == "boot" then
        local fmp7_path = M.config.fmp7_path
        if not fmp7_path or fmp7_path == "" then
            vim.notify("FMP.nvim: fmp7_path is not set", vim.log.levels.ERROR)
            return
        end

        if vim.fn.executable(fmp7_path) ~= 1 then
            vim.notify("fmp7_path value is invalid", vim.log.levels.ERROR)
            return
        end
        vim.system({ "cmd.exe", "/c", "start", "", fmp7_path }, { text = true, detach = true }, vim.schedule_wrap(function(obj)
            if obj.code ~= 0 then
                vim.notify("fmp7 exited with code: " .. obj.code, vim.log.levels.ERROR)
                return
            end
        end))

        return
    end

    run_main()
end

function M.FMP(args)
    local tokens = vim.fn.split(args)

    local cmd = tokens[1]
    if not cmd then
        vim.notify("No command specified", vim.log.levels.ERROR)
        return
    end

    if cmd == "play" then
        if #tokens < 2 then
            vim.notify("play requires path", vim.log.levels.ERROR)
            return
        end

        local path = table.concat(tokens, " ", 2)
        path = path:gsub('^"(.*)"$', "%1")

        if M.config.fadeout_before_play then
            M._run({ "fade", "--time", "10" })
        end

        M._run({ "play", "--path", path })
        return
    end

    if cmd == "stop" then
        M._run({ "stop" })
        return
    end

    if cmd == "pause" then
        M._run({ "pause" })
        return
    end

    if cmd == "fade" then
        local time = tokens[2]
        if time then
            M._run({ "fade", "--time", time })
        else
            M._run({ "fade" })
        end
        return
    end

    if (M.config.fmp7_path ~= nil) and (cmd == "boot") then
        M._run({ "boot" })
        return
    end

    vim.notify("Invalid command: " .. cmd, vim.log.levels.ERROR)
end


local function parse_exts(output)
    -- Ex:
    -- FMP7|*.owi,FMPv4|*.opi;*.ovi;*.ozi,...
    local exts = {}

    for group in output:gmatch("[^,]+") do
        local _, patterns = group:match("([^|]+)|(.+)")
        if patterns then
            for ext in patterns:gmatch("%*%.([%w%d]+)") do
                exts[ext:lower()] = true
            end
        end
    end

    return exts
end

function M._get_supported_exts()
    if M._ext_cache then
        return M._ext_cache
    end

    local result = vim.system({ M.config.FMP7_CLI_PATH, "get-exts" }, { text = true }):wait()
    local output = (result.stdout or "") .. (result.stderr or "")

    -- Windows想定（必要なら削除）
    output = vim.fn.iconv(output, "cp932", "utf-8")

    local exts = parse_exts(output)
    M._ext_cache = exts

    return exts
end

return M
