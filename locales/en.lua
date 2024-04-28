local Translations = {

    client = {
        lang_1 = 'Open ',
        lang_2 = 'Trapper Closed',
        lang_3 = 'come back after ',
        lang_4 = 'am',
        lang_5 = 'Trapper Menu',
        lang_6 = 'Sell to Trapper',
        lang_7 = 'sell your pelts, skins & feathers',
        lang_8 = 'Open Shop',
        lang_9 = 'browse the trapper shop',
        lang_10 = 'Trapper Checking...',
        lang_11 = 'Pelt Stored',
        lang_12 = 'your pelt has been stored',
        lang_13 = 'Something Went Wrong!',
        lang_14 = 'Animal Gathered: ',
        lang_15 = 'Animal Gathered: ',
        lang_16 = 'Trapper Shop',
        lang_17 = 'Open Trapper Menu',
    },

    server = {
        lang_1 = 'Nothing Found',
    },

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

-- Lang:t('client.lang_1')
-- Lang:t('server.lang_1')
-- Lang:t('config.lang_1')
