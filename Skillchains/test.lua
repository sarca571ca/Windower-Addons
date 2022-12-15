windower.register_event('prerender', function()
    local now = os.clock()

    if now < next_frame then
        return
    end

    next_frame = now + 0.1

    for k, v in pairs(resonating) do
        if v.times - now + 10 < 0 then
            resonating[k] = nil
        end
    end

    local targ = windower.ffxi.get_mob_by_target('t', 'bt')
    targ_id = targ and targ.id
    local reson = resonating[targ_id]
    local timer = reson and (reson.times - now) or 0

    if targ and targ.hpp > 0 and timer > 0 then
        if not reson.closed then
            reson.disp_info = reson.disp_info or check_results(reson)
            local delay = reson.delay
            local formTimer = '\\cs(0,255,0)Go!   %.1f\\cr'
            local formWait = '\\cs(255,0,0)Wait  %.1f\\cr'
            reson.timer = now < delay and
                formWait:format(delay - now) or
                formTimer:format(timer)
        elseif settings.Show.burst[info.job] then
            reson.disp_info = ''
            local formBurst = 'Burst %d'
            reson.timer = formBurst:format(timer)
        else
            resonating[targ_id] = nil
            return
        end
        reson.name = res[reson.res][reson.id].name
        local formChainbound = 'Chainbound Lv.%d'
        local formElement = '(%s)'
        reson.props = reson.props or not reson.bound and colorize(reson.active) or formChainbound:format(reson.bound)
        reson.elements = reson.elements or reson.step > 1 and settings.Show.burst[info.job] and formElement:format(colorize(sc_info[reson.active[1]])) or ''
        skill_props:update(reson)
        skill_props:show()
    elseif not visible then
        skill_props:hide()
    end
end)

