overlay = mp.create_osd_overlay("ass-events")
mp.observe_property("pause", "bool", function(name, val)
    mp.commandv("script-message", "osc-visibility", val and "always" or "auto", "no-osd")
    overlay:update()
    mp.add_timeout(0.05, function() overlay:remove() end)
end)
