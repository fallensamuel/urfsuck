-- "gamemodes\\rp_base\\gamemode\\default_config\\terms.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.AddTerm("CantUseWhileFight", "Вы не можете сделать этого во время боя! Подождите ещё # сек!")

rp.AddTerm('DupeWaitAnotherPly', 'Подождите, пока дубликат другого игрока будет создан.')

rp.AddTerm('CantAddMoreLikeReacts', 'Вы не можете поставить более 1 лайка в сутки!')
rp.AddTerm('JobLikeReactsRequired', 'Эта профессия требует # лайков! Вам нужно ещё # шт.')
rp.AddTerm("QMenuAmmoBuyed", "Вы купили # патрон за #")

rp.AddTerm("RequireUrfimInName", "Добавьте urf.im к вашему steam нику для активации этого бонуса!")

rp.AddTerm("ConfiscationFinish", "Вы конфисковали `#`! Награда: #")
rp.AddTerm("YouCantTradeNPC", "Вы не можете торговать с этим NPC!")

rp.AddTerm("WhiteListAdd", "Вам выдали профессию `#`!")
rp.AddTerm("WhiteListRemove", "У вас забрали профессию `#`!")
rp.AddTerm("WhiteListCant", "Вы не можете редактировать доступ к профессиям этого игрока!")

rp.AddTerm("PlayerTookSomeFromPrinter", "Вы пополнили # едениц!")

rp.AddTerm("HatsDonateOnly", "Эту шапку нельзя купить за внутриигровые деньги!")
rp.AddTerm("HatsInGameValutOnly", "Эту шапку нельзя купить за донат-валюту!")
rp.AddTerm('HatPurchasedDonate', 'Вы купили шапку # за #. (донат)')

rp.AddTerm("ToolgunMdlDonateOnly", "Эту модель нельзя купить за внутриигровые деньги!")
rp.AddTerm("ToolgunMdlInGameValutOnly", "Эту модель нельзя купить за донат-валюту!")
rp.AddTerm('ToolgunMdlPurchasedDonate', 'Вы купили модель # за #. (донат)')
rp.AddTerm('ToolgunMdlPurchased', 'Вы купили модель # за #.')

rp.AddTerm('ToolgunMdlEquipped', 'Модель # одета!')
rp.AddTerm('ToolgunMdlRemoved', 'Модель # снята!')

rp.AddTerm('CannotAffordDonate', 'У Вас не хватает донат-валюты!')

rp.AddTerm('DontUseCommandsSoFast', 'Не используйте команды так часто!')

rp.AddTerm('CantCreateDonateMultiplayer', 'Множитель пополняния не может быть меньше 10% или больше 2000%')
rp.AddTerm('CantCreateSkinsDonateMultiplayer', 'Множитель пополняния скинами не может быть меньше 10% или больше 2000%')
rp.AddTerm("SkinsDonateMultiplayerSuccess", "Бонус к пополнению скинами #% был активирован на # часов!")
rp.AddTerm("DonateMultiplayerSuccess", "Бонус к пополнению #% был активирован на # часов!")

rp.AddTerm("LawsUpdated", "Законы обновленны!")
rp.AddTerm("LawsReseted", "Законы сброшенны!")

rp.AddTerm("UNotPolice", "Вы не полицейский!")
rp.AddTerm("PlyTooFar", "Игрок слишком далеко!")
rp.AddTerm("UCantWithPolice", "Вы не можете # полицейского!")
rp.AddTerm("NeedsWantedReason", "Укажите причину розыска!")


-- To-do, add A LOT more of these

rp.AddTerm("PrecisionLimit", "Precision # ограниченн(а)! Вы не можете одновременно использовать более # #!")
rp.AddTerm('CandUseAnimWhileProne', 'Вы не можете использовать анимации находясь в положении лёжа.')

rp.AddTerm('DataNotLoaded', 'ВАШИ ДАННЫЕ НЕ ЗАГРУЖЕНЫ. ПОЖАЛУЙСТА, ПОДОЖДИТЕ. ЕСЛИ ЭТО СЛУЧИТСЯ СНОВА, ПОЖАЛУЙСТА, СООБЩИТЕ НАМ ОБ ЭТОМ!')
rp.AddTerm('PleaseWaitX', 'Пожалуйста, подождите # секунд для этого.')
rp.AddTerm('+Money', '+т.#')
rp.AddTerm('-Money', '-т.#')
rp.AddTerm('InvalidArg', 'Недействительный аргумент.')
rp.AddTerm('CantFindPlayer', 'Невозможно найти игрока #.')
rp.AddTerm('CannotAfford', 'У Вас не хватает денег!')
rp.AddTerm('NeedVIP', 'Вам нужен VIP статус! Напишите /upgrades чтобы купить.')
rp.AddTerm('NeedToWait', 'Вам нужно подождать # секунд чтобы сделать это!')
rp.AddTerm('ChangeJob', '# стал #.')
rp.AddTerm('CannotChangeJob', 'Вы не можете сменить работу в течении #!')
rp.AddTerm('ChangeName', '# изменил имя на #')
rp.AddTerm('Payday', 'Зарплата! Вы получили т.#.')
rp.AddTerm('PaydayTax', 'Зарплата! Вы получили т.# - т.# налог.')
rp.AddTerm('PayDayUnemployed', 'Вы не получили зарплату, потому что Вы - безработный!')
rp.AddTerm('PayDayMissed', 'Вы арестованы и не получили зарплату!')
rp.AddTerm('NotAllowedInSpawn', '# недопустимо на спавне!')
rp.AddTerm('LostKarma', 'Вы потеряли # очков Кармы, за #!')
rp.AddTerm('LostKarmaNR', 'Вы потеряли # очков Кармы.')
rp.AddTerm('LostKarmaDrugs', 'Вы потеряли # очков Кармы, за использование наркотиков.')
rp.AddTerm('SpawnPropsSoFast', 'Пожалуйста, спавните пропы не так быстро.')
rp.AddTerm('RPNameShort', 'RP имя должно быть длиннее # символов.')
rp.AddTerm('RPNameLong', 'RP имя должно быть короче # символов.')
rp.AddTerm('CannotRPName', 'Вы не можете изменить RP имя.')
rp.AddTerm('RPNameUnallowed', 'Это имя содержит недоступные символы (#).')
rp.AddTerm('RPNameWordLanguage', 'Каждое слово имени должно содержать либо кириллицу, либо латиницу.')
rp.AddTerm('SteamRPNameTaken', 'Ваше Steam-Имя уже используется кем-то, поэтому мы поставили "1" после Вашего имени.')
rp.AddTerm('RPNameTaken', 'Это RP имя уже взято ')
rp.AddTerm('EscapeDemotion', 'Вы пытаетесь избежать увольнения. У Вас не получилось, и Вы были уволены.')
rp.AddTerm('PlayerDemoted', '# был уволен.')
rp.AddTerm('PlayerNotDemoted', '# не был уволен.')
rp.AddTerm('DemotionStarted', '# начал голосование на увольнение #.')
rp.AddTerm('DemotionReason', 'Пожалуйста, укажите причину увольнения.')
rp.AddTerm('DemoteReasonLong', 'Ваша причина увольнения должна быть длиннее # characters.')
rp.AddTerm('DemoteSelf', 'Вы не можете уволить себя.')
rp.AddTerm('UnableToDemote', 'Вы не можете начать голосование.')
rp.AddTerm('ChannelLimit', 'Выберите канал от 0 до 100.')
rp.AddTerm('ChannelSet', 'Канал установлен на #.')
rp.AddTerm('ChannelNotSet', 'Вы не выставили свой канал!')
rp.AddTerm('GiveMoneyLimit', 'Вы не можете передать меньше чем т.1.')
rp.AddTerm('DropMoneyLimit', 'Вы не можете выбросить меньше т.1.')
rp.AddTerm('TooManyCheques', 'Вы выписали слишком много неиспользованных чеков!')
rp.AddTerm('ChequeArg1', 'Недействительный аргумент #1: получатель.')
rp.AddTerm('ChequeArg2', 'Недействительный аргумент #2: количество.')
rp.AddTerm('PlayerGaveCash', '# дал Вам #.')
rp.AddTerm('YouGaveCash', 'Вы дали # #.')
rp.AddTerm('MustLookAtPlayer', 'Вы должны смотреть на игрока.')
rp.AddTerm('HoesProfit', 'Ты заработал т.100 со своей шлюхи.')
rp.AddTerm('CannotAffordHoe', '# не может позволить себе Ваши услуги!')
rp.AddTerm('YouCannotAffordHoe', 'Вы не можете позволить себе услуги #!')
rp.AddTerm('GetCloser', 'Должен быть ближе к своей цели!')
rp.AddTerm('YouAreDead', 'Вы мертвы!')
rp.AddTerm('NotAHoe', 'Вы не проститутка.')
rp.AddTerm('NPCsDontFuck', 'Вы не можете заняться сексом с NPC.')
rp.AddTerm('TargetFrozen', 'Ваша цель заморожена.')
rp.AddTerm('WaitingForAnswer', 'В ожидании ответа.')
rp.AddTerm('TargetWontFuck', 'Ваша цель не желает заниматься сексом.')
rp.AddTerm('TargetTooFar', 'Ваша цель слишком далеко.')
rp.AddTerm('HoeTooFar', 'Ваша шлюха слишком далеко.')
rp.AddTerm('+FuckCostPimp', '+т.# - т.100 (доля сутенера)')
rp.AddTerm('WarrantTooMuch', 'Подождите, прежде чем снова выписать ордер.')
rp.AddTerm('WantedTooMuch', 'Подождите, прежде чем снова подать в розыск.')
rp.AddTerm('Warranted', 'Ордер на #. Причина: #, Выдал: #')
rp.AddTerm('Wanted', '# в розыске. Причина: #, Выдал: #')
rp.AddTerm('Arrested', '# арестован.')
rp.AddTerm('UnArrested', '# выпущен из тюрьмы.')
rp.AddTerm('DoorUpgraded', 'Дверь улучшена! Взлом теперь длится дольше.')
rp.AddTerm('DoorCantUpgrade', 'Не хватает денег на улучшение!')
rp.AddTerm('DoorLocked', 'Закрыто!')
rp.AddTerm('DoorUnlocked', 'Открыто!')
rp.AddTerm('MaxDoors', 'Вы достигли максимального количества купленных дверей!')
rp.AddTerm('DoorBought', 'Вы оплатили аренду за #.')
rp.AddTerm('DoorOwnerAdded', '# был добавлен в Вашу дверь.')
rp.AddTerm('DoorOwnerAddedYou', '# добавил Вас в свою дверь.')
rp.AddTerm('DoorOwnerRemoved', '# был удалён из Вашей двери.')
rp.AddTerm('DoorOwnerRemovedYou', '# удалил из своей двери.')
rp.AddTerm('DoorSold', 'Вы продали дверь за #.')
rp.AddTerm('DoorSoldFree', 'Вы продали дверь.')
rp.AddTerm('DoorTitleSet', 'Название двери установленно .')
rp.AddTerm('OrgDoorEnabled', 'Владение организации разрешено')
rp.AddTerm('OrgDoorDisabled', 'Владение организации запрещено .')
rp.AddTerm('NoDoors', 'У Вас нет дверей на продажу.')
rp.AddTerm('DoorsSold', 'Вы продали # дверь за #.')
rp.AddTerm('DoorsSoldFree', 'Вы продали свои двери.')
rp.AddTerm('EventEnded', '# Ивент закончился.')
rp.AddTerm('OrgDisbanded', '# был распущен!')
rp.AddTerm('OrgPlayerKicked', '# кикнут из организации #.')
rp.AddTerm('OrgPlayerYoureKicked', 'Вы были кикнуты из организации #.')
rp.AddTerm('OrgMustLeaveFirst', 'Вам нужно покинуть организацию чтобы создать новую.')
rp.AddTerm('OrgNameShort', 'Пожалуйста, сделайте название своей организации длиннее чем 2 буквы.')
rp.AddTerm('OrgNameLong', 'Пожалуйста, сделайте название своей организации короче чем чем 20 букв.')
rp.AddTerm('OrgNameTaken', 'Это имя уже занято. Пожалуйста выберите другое!')
rp.AddTerm('OrgCannotAfford', 'Вы не можете позволить себе создать организацию.')
rp.AddTerm('OrgCannotAffort', 'Вы не можете позволить себе создать организацию.')
rp.AddTerm('OrgCreated', 'Вы успешно создали свою организацию.')
rp.AddTerm('OrgMOTDChanged', 'Вы изменили вашу организацию MoTD.')
rp.AddTerm('OrgColorChanged', 'Вы изменили цвет организации.')
rp.AddTerm('OrgPlayerQuit', '# вышел из #!')
rp.AddTerm('OrgMemberLimit', 'Вы достигли максимального количество # членов в организации!')
rp.AddTerm('OrgMemberJoined', '# присоединился к #.')
rp.AddTerm('OrgMemberInvite', 'Вы пригласили # в организацию.')
rp.AddTerm('OrgMemberInviteDismiss', '# отказался от приглашения в организацию.')
rp.AddTerm('MustBeMayorSetLaws', 'Вы должны быть Мэром чтобы установить закон!')
rp.AddTerm('MustBeMayorResetLaws', 'Вы должны быть Мэром чтобы сбросить законы!')
rp.AddTerm('LotteryTax', 'Вы заработали # в лотереи.')
rp.AddTerm('LotteryWinner', '# выиграл # в лотерее!')
rp.AddTerm('NoLottery', 'Никто не участвовал в лотерее, поэтому Ваши деньги были возвращены.')
rp.AddTerm('NoLotteryTax', 'Вы заработали т.0 в лотереи потому, что никто не участвовал.')
rp.AddTerm('NotInLottery', 'Вы не участвуете в лотерее.')
rp.AddTerm('InLottery', 'Вы участвуете в лотерее за  #.')
rp.AddTerm('NoLotteryAll', 'Никто не участвует в лотерее.')
rp.AddTerm('CannotLottery', 'Вы не можешь учавствовать в лотерее прямо сейчас.')
rp.AddTerm('LottoCooldown', 'Пожалуйста, подождите # секунд чтобы начать лотерею')
rp.AddTerm('LottoCost', 'Пожалуйста, установ цену на вход (т.#-т.#).')
rp.AddTerm('LotteryStarted', 'Лотерея началась!')
rp.AddTerm('CannotLockdown', 'Комендантский час сейчас недоступен.')
rp.AddTerm('LockdownStarted', 'Объявлен #!')
rp.AddTerm('CannotUnlockdown', 'Вы не можете отменить комендантский час сейчас.')
rp.AddTerm('LockdownEnded', '# окончен.')
rp.AddTerm('WarrantExpired', 'Ваш ордер просрочен.')
rp.AddTerm('WantedPlayerNotFound', '# не найден!')
rp.AddTerm('PlayerAlreadyWanted', '# Уже разыскивается!')
rp.AddTerm('PlayerAlreadyWarranted', '# Уже есть ордер!')
rp.AddTerm('PlayerNotWanted', '# не разыскивается!')
rp.AddTerm('PlayerNotWarranted', 'На # нет ордера!')
rp.AddTerm('WarrantRequestAcc', 'Ваш ордер одобрен.')
rp.AddTerm('WarrantRequestDen', 'Ваш ордер был отклонён.')
rp.AddTerm('HitComplete', 'Заказ на # выполнен.')
rp.AddTerm('YourHitComplete', 'Вы были убит наёмным убийцей.')
rp.AddTerm('HitTargetInvalid', 'Вы должны выбрать правильную цель!')
rp.AddTerm('CantHitYourself', 'Вы не можете заказать себя!')
rp.AddTerm('CantHitHitman', 'Вы не можете заказать Наёмника!')
rp.AddTerm('CantPlaceHit', 'Наёмник не может делать заказ!')
rp.AddTerm('HitPriceLimit', 'Цены на заказ должны быть от # и до #.')
rp.AddTerm('HitTimer', 'Вы не можете нанести удар в течении # секунд.')
rp.AddTerm('MultiHit', 'Вы не можете заказать одного и того же человека так часто!')
rp.AddTerm('BountyIncrease', 'Вы увеличили вознаграждение за # на #.')
rp.AddTerm('HitPlaced', 'Вы сделали заказ на # за #.')
rp.AddTerm('HitmanFailed', 'Вы потерпели неудачу в качестве киллера!')
rp.AddTerm('EmployeeChangedJob', 'Ваш наниматель изменил работу!')
rp.AddTerm('EmployeeChangedJobYou', 'Ваш контракт был отменён потому, что вы сменили работу!')
rp.AddTerm('EmployeeDied', 'Ваша цель умерла!')
rp.AddTerm('EmployeeDiedYou', 'Ваш контракт был отменён потому что, Вы - умерли!')
rp.AddTerm('EmployerDied', 'Ваш наниматель умер!')
rp.AddTerm('EmployerDiedYou', 'Ваш работник уволен потому, что вы умерли.')
rp.AddTerm('EmployeeLeft', 'Ваша цель отключилась!')
rp.AddTerm('EmployerLeft', 'Ваш наниматель отключился!')
rp.AddTerm('PlayerNotHirable', '# не может быть нанят.')
rp.AddTerm('EmployeeTriedEmploying', 'В данный момент Вы ищете работу. Вы не можете нанять рабочего !')
rp.AddTerm('HasEmployee', 'Вы уже наёмный работник!')
rp.AddTerm('AlreadyEmployed', 'Вы уже нанят!')
rp.AddTerm('CannotAffordEmployee', 'Вы не можете нанять!')
rp.AddTerm('EmployRequestSent', 'Вы отправили # запрос на найм.')
rp.AddTerm('YouHired', 'Вас нанял # для #.')
rp.AddTerm('YouAreHired', '# нанял Вас для #.')
rp.AddTerm('EmployRequestDen', '# отменил вашу заявку на работу.')
rp.AddTerm('EmployeeFired', 'Вы уволены #.')
rp.AddTerm('EmployeeFiredYou', '# Уволил вас!')
rp.AddTerm('EmployeeQuit', '#Вышел с работы вместе с вами!')
rp.AddTerm('EmployeeQuitYou', 'Вы ушли с работы #.')
rp.AddTerm('CannotTool', 'Недостаточно прав использовать "#" инструмент!')

rp.AddTerm('GetNewDupe', 'Получен новый дюп от игрока #.')
rp.AddTerm('DupeSended', 'Дюп был передан игроку #.')
rp.AddTerm('DupeExists', 'Игрок уже имеет такой дюп!')
rp.AddTerm('DupeSendTask', 'Выполняется передача дюпа игроку...')
rp.AddTerm('DupeRestrictedEnts', 'Вы не можете создавать дупликаты этих объектов!')
rp.AddTerm('DupeCopied', 'Постройка успешно скопирована.')
rp.AddTerm('DupePasted', 'Постройка успешно воссоздана.')
rp.AddTerm('DupeSaved', 'Постройка успешно сохранена.')
rp.AddTerm('DupeLoaded', 'Сохранение успешно загружено.')
rp.AddTerm('DupeDeleted', 'Сохранение удалено.')
rp.AddTerm('DupeWait', 'Дождитесь, пока текущий дубликат будет создан.')
rp.AddTerm('EndDupeSlots', 'Достигнуто максимальное число сохранений: #.')
rp.AddTerm('LimitDupeProps', 'Достигнут лимит пропов в дюпе: #.')

rp.AddTerm("DupeDistanceLimit", "Подойдите ближе к воссоздоваемой постройке!")

rp.AddTerm('WhitelistFull', ' Белый Список полон #/750')
rp.AddTerm('CacheFull', 'Модель Кэша заполнена #/100!')
rp.AddTerm('PropWhitelisted', '# добавлен в Белый Список #.')
rp.AddTerm('PropBlacklisted', '# был помещен в Черный Список #.')
rp.AddTerm('PPTargNotFound', 'Цель не найдена!')
rp.AddTerm('UnsharedPropsYou', 'Вы отменили доступ к своим пропам для #.')
rp.AddTerm('UnsharedProps', '# отменил вам доступ к своим пропам.')
rp.AddTerm('SharedPropsYou', 'Вы открыли доступ к своим пропам для  #.')
rp.AddTerm('SharedProps', '# Предоставил доступ к своим пропам для вас.')
rp.AddTerm('PPGroupSet', '# был добавлен в группу # by #.')
rp.AddTerm('PropNotWhitelisted', '# не в вайтлисте!')
rp.AddTerm('NoPMResponder', 'Там никого нет чтобы ответить')
rp.AddTerm('CannotDestroyWeapon', 'Вы не можете уничтожить это оружие!')
rp.AddTerm('YourEntDestroyed', 'Ваше # было уничтожено!')
rp.AddTerm('InvalidURL', 'не правильный URL!')
rp.AddTerm('VideoFailed', 'Не удалось загрузить видео: #.')
rp.AddTerm('FoodLimitReached', 'Вы достигли лимита еды!')
rp.AddTerm('BoughtFoodProduction', 'Вы заплатили # за продукты.')
rp.AddTerm('SoldFoodNoProf', 'Вы продали еду и не получили денег, но заработали 3 Кармы.')
rp.AddTerm('SoldFood', 'Вы продали еду и заработали # и получили  1 карму.')
rp.AddTerm('BoughtFood', 'Вы купили еду для #.')
rp.AddTerm('ThereIsACook', 'Есть повар. Вы не можете сделать этого!')
rp.AddTerm('EmptyShipment', 'Там нет товаров.')
rp.AddTerm('GCMessageLimit', 'Ваше сообщение должно быть больше чем 1 буква!')
rp.AddTerm('CantSuicideJail', 'Вы не можете покончить жизнь самоубийством в тюрьме.')
rp.AddTerm('CantSuicideWanted', 'Вы не можете покончить жизнь самоубийством пока вы в розыске .')
rp.AddTerm('CantSuicideFrozen', 'Вы не можете покончить жизнь самоубийством пока вы freeze.')
rp.AddTerm('CantSuicideLiveFor', 'Вам ещё долго жить!')
rp.AddTerm('YouSuicided', 'Вы опозорили свою семью!')
rp.AddTerm('CantPurchaseUpgrade', 'Вы не можете купить это. #')
rp.AddTerm('RPItemBought', 'Вы купили # за #.')
rp.AddTerm('CantAdminCleanup', 'Вы не можете использовать админскую очистку!')
rp.AddTerm('MayorHasDied', 'Мэр мёртв!')
rp.AddTerm('YouWereBailed', '# освободил тебя из тюрьмы!')
rp.AddTerm('ArmorLabProfit', 'Вы заработали т.# из своей armor lab.')
rp.AddTerm('BoughtArmor', 'Вы купили Броне-Лабу за т.#.')
rp.AddTerm('ArmorLabExploded', 'Ваша Броне-Лаба взорвалась!')
rp.AddTerm('ChequeFound', 'Вы нашли # в чеке записанном на тебя #.')
rp.AddTerm('ChequeMadeTo', '"Этот чек сделан к  #.')
rp.AddTerm('ChequeTorn', 'Вы разорвали чек.')
rp.AddTerm('MoneyFound', 'Вы нашли т.#!')
rp.AddTerm('MustBeHobo', 'Только бомжи могут это делать!')
rp.AddTerm('HaveNotMask', 'У вас нет маски!')
rp.AddTerm('AlreadyDisguised', 'Вы уже замаскированы!')
rp.AddTerm('GunLicenseActive', 'Вы активировали лицензию на оружие.')
rp.AddTerm('YouGotAIDS', 'Вы заразились сифилисом.')
rp.AddTerm('YouGotHerpes', 'Вы заразились герпесом от иглы.')
rp.AddTerm('STDCured', 'Вы вылечились от сифилиса.')
rp.AddTerm('NowDisguised', 'Вы замаскированы как #.')
rp.AddTerm('NowDisguisedTime', 'Вы замаскированы на # как #.')
rp.AddTerm('DisguiseWorn', 'Ваша маскировка закончилась.')
rp.AddTerm('DisguiseLimit', 'Вы не можете маскироваться ещё # минут.')
rp.AddTerm('MedLabProfit', 'Вы заработали т.# на своей Мед-Лабу.')
rp.AddTerm('BoughtHealth', 'Вы купили здоровье за т.#.')
rp.AddTerm('MedLabExploded', 'Ваша Мед-Лаба взорвалась!')
rp.AddTerm('KeypadControlsX', 'Этот кейпад контролирует # объект.')
rp.AddTerm('EntityControlledByX', 'Этот объект под контролем  # кейпада.')
rp.AddTerm('VoteAlone', 'Вы выиграли выборы поскольку были единственным кандидатом.')
rp.AddTerm('BannedFromJob', 'В настоящее время эта работа недоступна для вас.')
rp.AddTerm('VotedTooSoon', 'Пожалуйста, подождите # секунд чтобы начать голосование.')
rp.AddTerm('AlreadyThisJob', 'Вы уже на этой работе!')
rp.AddTerm('JobLimit', 'Лимит достигнут.')
rp.AddTerm('RegisteredForVote', 'Вы зарегистрированы на предстоящие выборы!')
rp.AddTerm('AlreadyVoting', 'Выборы уже начались. Вы опоздали!')
rp.AddTerm('JobNeedsAdmin', 'Вы должны быть moderator+ для этой работы.')
rp.AddTerm('JobNeedsSA', 'Вы должны быть SA+ для этой работы.')
rp.AddTerm('JobNeedsBanned', 'Ты должен быть забанен на сервере чтобы получить этот класс')
rp.AddTerm('IncorrectJob', 'У вас не та работа чтобы сделать это!')
rp.AddTerm('VoteStarted', 'Голосование создано.')
rp.AddTerm('CannotJob', 'Вы не можете изменить работу прямо сейчас.')
rp.AddTerm('JobLenShort', 'Название работы должно быть больше чем # буква.')
rp.AddTerm('JobLenLong', 'Название работы должно быть меньше чем  # букв.')
rp.AddTerm('CannotPurchaseItem', 'Вы не допущены к покупке этого предмета.')
rp.AddTerm('ItemLimit', 'Вы достигли # лимит.')
rp.AddTerm('ItemUnavailable', 'Эта вещь недоступна.')
rp.AddTerm('UnableToItem', 'Вы не в состоянии купить эту вещь.')
rp.AddTerm('ShipmentCooldown', 'Подождите прежде чем спавнить товар.')
rp.AddTerm('MedicExists', 'Вы не можете купить HP потому, что есть медик.')
rp.AddTerm('HealthIsFull', 'Ваше здоровье уже полное!')
rp.AddTerm('CannotDropWeapon', 'Вы не можете выкинуть это оружие!')
rp.AddTerm('LookAtEntity', 'Вы дожны смотреть на объект!')
rp.AddTerm('CannotSetPrice', 'Вы не можете установить цену на этот объект !')
rp.AddTerm('AnalProlapse', 'Вы перенапрягли анус и умерли от пролапса.')
rp.AddTerm('NoMorePoo', 'У тебя больше нет каках !')
rp.AddTerm('NotARapist', 'Вы не насильник.')
rp.AddTerm('RapeNPC', 'Вы не можете насиловать NPC.')
rp.AddTerm('RapeFailed', 'Попытка изнасилования провалена!')
rp.AddTerm('RapeAttempted', 'Кто-то пытается вторгнуться в вашу жопу.')
rp.AddTerm('Raped', 'Вас изнасиловал #, засадив вам прямо в зад.')
rp.AddTerm('YouAreRaped', 'Кто-то вторгается в ваш зад.')
rp.AddTerm('AnalProlapseShort', 'Вы умерли от анального пролапса.')
rp.AddTerm('DickFellOff', 'Ваш член отвалился.')
rp.AddTerm('CannotVote', 'Вы не можете голосовать.')
rp.AddTerm('CantDoThis', 'Вы не можете сделать это.')
rp.AddTerm('BaitingRule', 'Это не по правилам.')
rp.AddTerm('FoundNothing', 'Вы ничего не нашли.')
rp.AddTerm('RobberyAttempt', 'Вы чувствуете лёгкое движение в кармане.')
rp.AddTerm('RobberyFailed', 'Ограбление провалено!')
rp.AddTerm('YouRobbed', 'Вы украли т.#!')
rp.AddTerm('YouAreRobbed', 'Ваш карман облегчился.')
rp.AddTerm('NoteUpdated', 'Текст обновлен.')
rp.AddTerm('USENote', 'Нажмите использовать чтобы редактировать текст.')
rp.AddTerm('OrgYouAreStuck', 'Вы застряли! >:)')
rp.AddTerm('OrgYourRank', '# установил ваш ранг \'#\'.')
rp.AddTerm('OrgSetRank', '# добавлен \'#\'.')
rp.AddTerm('OrgUnknownRank', 'неизвестный ранг \'#\'.')
rp.AddTerm('OrgRankRename', 'Ранг \'#\' переименован в \'#\'.')
rp.AddTerm('OrgReorderLimit', 'Вы не можете изменить Высший и Низший ранги.')
rp.AddTerm('OrgRankUpdated', 'Ранг \'#\' обновлен.')
rp.AddTerm('OrgMaxRanks', 'Максимальный ранг достигнут.')
rp.AddTerm('OrgRankCreated', 'Ранг \'#\' Создан.')
rp.AddTerm('OrgDeleteLimit', 'Вы не можете удалить высший и низший ранг.')
rp.AddTerm('OrgRankDelete', 'Ранг \'#\' удалён.')
rp.AddTerm('OrgBannerUpdated', 'Банер обновлён.')
rp.AddTerm('FadeDoorCreated', 'Fading door создан.')
rp.AddTerm('FadeDoorCreatedExtra', 'Fading door создан. Теперь, правый клик чтобы создать кейпад.')
rp.AddTerm('InvalidPassword', 'неверный пароль!')
rp.AddTerm('KeypadHoldLength', 'Время удержание должно быть не менее # секунд.')
rp.AddTerm('KeypadCreated', 'Кейпад создан.')
rp.AddTerm('SboxPropLimit', 'Вы достигли лимита пропов!')
rp.AddTerm('SboxXLimit', 'Вы достигли # лимит')
-- Entities folder
rp.AddTerm('ArcadeMachineUse', 'Приготовьтесь к игре!')
rp.AddTerm('PlayerNotInJail', '# не в тюрьме.')
rp.AddTerm('PlayerFuckedBailing', 'Ты придурок, копы у тебя на хвосте!')
rp.AddTerm('PlayerBailedPlayer', '# заплатил за вас выкуп #.')
rp.AddTerm('PlayerTookDonationBox', 'Вы взяли #.')
rp.AddTerm('YouDontOwnThis', 'Вы не владеете этим!')
rp.AddTerm('PlayerReceivedDonationBox', 'Кто-то пожертвовал # в вашу коробку для пожертвования.')
rp.AddTerm('DrugLabExploded', 'Ваша нарко-лаборатория взорвалась!')
rp.AddTerm('PlayerNotWanted', 'Этот игрок не разыскивается!')
rp.AddTerm('PlayerTookMoneyBasket', 'Вы взяли #.')
rp.AddTerm('PrinterIsFull', 'Этот принтер полон чернилами!')
rp.AddTerm('PrinterRefilled', 'Вы заправили принтер за #.')
rp.AddTerm('PrinterExploded', 'Ваш принтер взорвался!')
rp.AddTerm('PrinterFixed', 'Вы починили принтер!')
rp.AddTerm('PlayerSoldDrugs', 'Вы продали # за #.')
-- Weapons folder
rp.AddTerm('ArrestBatonBonus', 'Вы заработали # бонус за уничтожение нелегального объекта.')
rp.AddTerm('ArrestBatonArrested', 'Вас арестовал #.')
rp.AddTerm('ArrestBatonYouArrested', 'Вы арестовали # и заработал 2 кармы.')
rp.AddTerm('PlayerRangDoorbell', 'Кто-то звонит в ваш дверной звонок.')
rp.AddTerm('KeysCooldown', 'Пожалуйста, подождите прежде чем закрывать дверь')
rp.AddTerm('UnarrestBatonTarg', 'Вас выпустил из тюрьмы #.')
rp.AddTerm('UnarrestBatonOwn', 'Вы освобождены #.')
rp.AddTerm('RiotShieldInSpawn', 'Пожалуйста, покиньте спавн чтобы использовать этот щит!')
rp.AddTerm('HatPurchased', 'Вы купили шапку # за #.')
rp.AddTerm('HatEquipped', 'Шапка одета!')
rp.AddTerm('HatRemoved', 'Шапка снята!')
rp.AddTerm('BURGHungerImmune', 'У вас иммунитет к голоду пока вы не умрёте!')
rp.AddTerm('BURGNotPeople', 'Глупый бургер, бургер не человек!')

rp.AddTerm('KarmaAdeed', 'Господь отпустил ваши грехи!')
rp.AddTerm('KarmaCooldown', 'Вашу праведность стоило бы доказать делом!')
rp.AddTerm('GoodKarmaGain', 'Последнее время вы вели праведный образ жизни и получили # кармы!')

rp.AddTerm('NotEnoughTime', 'У вас отыграно слишком мало времени!')
rp.AddTerm('ConfirmAction', 'Подтвердите действие')
rp.AddTerm('UnlockTeam', 'Разблокировать # за #?')
rp.AddTerm('TeamUnlocked', 'Поздравляем с разблокировкой!')

rp.AddTerm('WantedReasons', {'Ампутация', 'Перевоспитание', 'Карцер'})

rp.AddTerm('nu.vehicleNotOwned', 'Вы не являетесь владельцем этого транспортного средства!')
rp.AddTerm('nu.vehicleSold', 'Вы продали # за т.# !')
rp.AddTerm('nu.vehicleBought', 'Вы купили # за т.#!')
rp.AddTerm('nu.vehicleReturned',  'Вы вернули свою машину!')
rp.AddTerm('nu.returnVehicleFirst', 'Вам нужно вернуть своё транспортное средство прежде чем брать другое!')
rp.AddTerm('nu.vehicleRestricted', 'Вы не можете спавнить этот автомобиль')
rp.AddTerm('nu.noMoneyForFee', 'У вас недостаточно средств, чтобы заплатить за спавн автомобиля.')
rp.AddTerm('nu.spawnVehicleFeeMsg', 'Вы заплатили т.# за спавн #')
rp.AddTerm('nu.vehicleGranted', 'Вам дали автомобиль: # на #!')
rp.AddTerm('nu.vehicleRevoked', 'Вы забрали у # право на #!')
rp.AddTerm('nu.vehiclesForceReturned', 'Все ваши машины были возвращены #!')
rp.AddTerm('nu.alreadyOwned', 'У вас есть уже этот автомобиль!')
rp.AddTerm('nu.notEnoughMoney', 'У вас нет денег для того, чтобы купить этот автомобиль!')
rp.AddTerm('nu.spawn', 'Доставить')
rp.AddTerm('nu.nu.return', 'Вернуть')
rp.AddTerm('nu.purchase', 'Купить')
rp.AddTerm('nu.sell', 'Продать')
rp.AddTerm('nu.manager', 'Менеджер')
rp.AddTerm('nu.mods', 'Тюннинг')
rp.AddTerm('nu.paint', 'Цвет')
rp.AddTerm('nu.selectVehicleFirst', 'Сперва выберите автомобиль!')
rp.AddTerm('nu.saleEndsIn', 'Продам за: #')
rp.AddTerm('nu.shop','Магазин')
rp.AddTerm('nu.searchByTags', 'Поиск..')

rp.AddTerm('loyalty', {'Низкая', 'Средняя', 'Высокая', 'Максимальная', 'Карта заблокирована', 'Карта заблокирована: Нарушитель номер один', 'Карта заблокирована: Статус Анти-Гражданин', 'Карта заблокирована: Злостный нарушитель', 'Карта заблокирована: Антиобщественная деятельность', 'Карта заблокирована: Вы Админчик'})
rp.AddTerm('CannotSeatOnEntity', 'Вы не можете сесть на сюда.')
rp.AddTerm('MaxMoneyPrinterReached', 'Вы достигли лимита печатных станков!')

rp.AddTerm('MayorDelay', 'После смерти Администратора необходимо подождать '..rp.cfg.MayorDelay..' секунд, чтобы им стать!')
rp.AddTerm('MayorKilled', '# убил Администратор Города! Повстанцы получают т.'..rp.cfg.MayorKillReward..'!')
rp.AddTerm('MayorSalaryIncrease', 'Администратор Города увеличивает вашу заработную плату!')
rp.AddTerm('MayorKilledByIncident', 'Администратор Города умер из-за несчастного случая!')

rp.AddTerm('SelectSpawnPointLabel', 'Переехать в #')
rp.AddTerm('SelectSpawnPoint', 'Вы будете возрождаться в этом месте.')

rp.AddTerm('SpawnPointInvalidJob', 'У вас неподходящая профессия для переезда.')
rp.AddTerm('SpawnPointChanged', 'Вы переехали в #, теперь вы будете возрождаться здесь.')

rp.AddTerm('OTAYouveBeenReprogrammed', 'Вас перепрограммировал #, теперь вы обязаны выполнять его приказы.')
rp.AddTerm('OTAHasBeenReprogrammed', 'Вы перепрограммировали #, теперь он обязаны выполнять ваши приказы.')
rp.AddTerm('OTAReprogrammLimitReached', 'Вы уже подчинили себе OTA.')

--rp.AddTerm('ZombieKillReward', 'Вы получили т.'..rp.cfg.ZombieReward..' за убийство.')
rp.AddTerm('ZombieKillReward', 'Вы получили т.# за убийство.')
rp.AddTerm('FactionKillReward', 'Вы получили # за убийство.')

rp.AddTerm('MaxMoneyPrinterReached', 'Вы достигли лимита печатных станков (максимум 3)!')

rp.AddTerm('PlayerSoldArtToBartender', "Вы передали наркотики и получили # (+30%).")
rp.AddTerm('BartenderPurchasedArtFromPly', "Вы приняли наркотики и получили #.")
rp.AddTerm('RationReward', "Вы получили т.# (увеличенный рацион).")

rp.AddTerm('NPCKilled', 'Вы получили т.# за убийство пришельца!')

rp.AddTerm('LegKilled', "Святой Джек был убит! Но он обязательно вернется! Убийцы Джека получили по 15 кредитов.")

rp.AddTerm('9thLegion', "Вы должны быть членом организации 9-th Legion!")
rp.AddTerm('Vipers', "Вы должны быть членом организации Viper!")
rp.AddTerm('Totenkopf_SS', "Вы должны быть членом организации Totenkopf_SS!")
rp.AddTerm('New Order', "Вы должны быть членом организации New Order!")
rp.AddTerm('Sons of Sunrise', "Эта профессия более недоступна для получения или покупки никаким образом!")
rp.AddTerm('OTA.Anti-Human', "Вы должны быть членом организации OTA.Anti-Human!")
rp.AddTerm('AntihumanSpeedBoost', 'OTA.ANTI-HUMAN.Savior увеличивает отряду ANTI-HUMAN скорость бега и броню!')

rp.AddTerm('Lambda Soldiers', "Вы должны быть членом организации Lambda Soldiers!")
rp.AddTerm('SPD Revork', "Вы должны быть членом организации SPD Revork!")
rp.AddTerm('OMEGA', "Вы должны быть членом организации OMEGA!")
rp.AddTerm('Blackout', "Вы должны быть членом организации Blackout!")
rp.AddTerm('Peacekeepers', "Вы должны быть членом организации Peacekeepers!")
rp.AddTerm('Mercenary Guild', "Вы должны быть членом организации Mercenary Guild!") 
rp.AddTerm('Bloody Syndicate', "Вы должны быть членом организации Bloody Syndicate!")

rp.AddTerm('PointWasCaptured', '# захватили #.')
rp.AddTerm('PointWasDefended', '# отстояли #.')
rp.AddTerm('CapturePointWasNotSelected', '# не выбрали территорию для атаки.')
rp.AddTerm('NotYourTurnToCapture', 'Перед следующей атакой надо подождать # секунд!')
rp.AddTerm('TooEarlyToCapture', 'Предыдущая атака ещё не закончена.')
rp.AddTerm('CapturePointAlreadySelected', 'Вы уже выбрали территорию для нападения (#)!')
rp.AddTerm('CaptureStarted', '# начали атаку на территорию # (владелец: #)!')
rp.AddTerm('CantCaptureOwnTerritory', 'Эй приятель, ты что, совсем тупой? Это уже твоя территория!')
rp.AddTerm('StayOnPointYouWishToCapture', 'Встань на территорию, которую собираешься атаковать!')
rp.AddTerm('CaptureIncome', 'Доход от территорий: # токенов!')
rp.AddTerm('EverythingIsCaptured', 'Вы контролируете все территории, пора задуматься об обороне!')
rp.AddTerm('TooLowAttackersForCapture', 'Вам нужно еще # напарников для атаки на территорию!')

rp.AddTerm('NotEnoughToSteal', 'Карманы этого нищего совершенно пусты!')
rp.AddTerm('SomeoneStoulenMoneyFromYou', 'Вы обнаружили, что кто-то стащил у Вас из кармана т.#!')

rp.AddTerm('WearUsed', 'Вы переоделись. Напишите /unequip чтобы вернуть свой внешний вид.')
rp.AddTerm('WearReset', 'Вы вернули свой изначальный внешний вид, напишите /equip чтобы переодеться снова.')
rp.AddTerm('CantWear', 'У вас неподходящая профессия.')

rp.AddTerm('PlaceLockOnDoor', 'Прикрепите замок к двери при помощи рук!')

rp.AddTerm('RequireAlliance', 'Вы должны состоять в организации Overwatch C18')
rp.AddTerm('RequireRebel', 'Вы должны состоять в организации Resistance')

rp.AddTerm( "AppearanceSaved",      "Вы переоделись!" );

rp.AddTerm('ShopSaleStart', 'Скидка #% в донат магазине активирована на # часов.')

rp.AddTerm("JobRecovery", "Ваша работа была восстановлена!")

rp.AddTerm("SaveProps", "Ваши пропы и предметы были сохранены!")
rp.AddTerm("LoadProps", "Ваши пропы и предметы были восстановлены!")

rp.AddTerm( "SupervisorUpgradedInfo", "Ваше обмундирование было улучшено диспетчером." );
rp.AddTerm( "SupervisorUpgradedWeps", "Вам было выдано следующее оружие: #" );

rp.AddTerm("BackweaponEnabled", "Отображение оружия за спиной включено.")
rp.AddTerm("BackweaponDisabled", "Отображение оружия за спиной выключено.")

--NY
rp.AddTerm( 'NyGift',      "Вы нашли подарок и получили 5 кредитов!" ); 

-- EmoteActions:
rp.AddTerm( "EmoteActions.CannotDo",         "Вы не можете выполнить это действие." );
rp.AddTerm( "EmoteActions.CannotVehicle",    "Вы не можете выполнить это действие находясь в транспорте." );
rp.AddTerm( "EmoteActions.CannotUnderwater", "Вы не можете выполнить это действие находясь в воде." );
rp.AddTerm( "EmoteActions.CannotNoclip",     "Вы не можете выполнить это действие находясь в режиме полета." );
rp.AddTerm( "EmoteActions.CannotLadder",     "Вы не можете выполнить это действие находясь на лестнице" );
rp.AddTerm( "EmoteActions.CannotAir",        "Вы не можете выполнить это действие находясь в воздухе." );
rp.AddTerm( "EmoteActions.CannotCrouch",     "Вы не можете выполнить это действие из положения сидя" );
rp.AddTerm( "EmoteActions.CannotVelocity",   "Вы не можете выполнить это действие на ходу." );
rp.AddTerm( "EmoteActions.CannotItems",      "Вам необходимо держать: # в руках для этого действия." );    
rp.AddTerm( "EmoteActions.NotEnoughSpace",   "Недостаточно места для выполнения этого действия." );

rp.AddTerm('MaxCarReached', 'Вы достигли лимита машин!')

rp.AddTerm('DonatesEmpty', 'У этого игрока нет покупок в донат магазине!')
rp.AddTerm('DonatesFailed', 'Что-то пошло не так, возврат не будет совершен.')
rp.AddTerm('DonatesSuccessful', 'Вы вернули # кредитов за # игроку #!')

rp.AddTerm('InvCantOpenFaction', 'Это имущество чужой фракции!')

rp.AddTerm('FadeDoorCooldown', 'Подождите # сек, чтобы выполнить это действие')
rp.AddTerm("SignalizationWasActivated", "Сработала Сигнализация #")

rp.AddTerm('OOCCooldown', 'Перестань портить атмосферу! Периодичность сообщений 5 секунд.')

rp.AddTerm( "HeistGoing",  "Внимание, происходит #!" );

rp.AddTerm( "ArmHeistNotBadGuy",  "Вы не являетесь бандитом/криминалом." );
rp.AddTerm( "ArmHeistCooldown",  "Ограбление находится в перезарядке." );
rp.AddTerm( "ArmHeistInProgress",  "Ограбление уже в процессе!" );
rp.AddTerm( "ArmHeistPoliceHelp",  "Вы получили награду в размере # за предотвращение ограбления." );
rp.AddTerm( "ArmHeistPoliceEntered",  "Вы получили # за участие в предотвращении ограбления." );

rp.AddTerm("ScoreboardReactSet", "Вы поставили лайк игроку #!")
rp.AddTerm("ScoreboardReacted", "Игрок # поставил вам лайк!")
rp.AddTerm("ScoreboardReactUnset", "Вы сняли лайк с игрока #!")
rp.AddTerm("ScoreboardReactMyself", "Вы не можете поставить лайк самому себе!")

rp.AddTerm("GlobalRankGiven", "# получил пакет '#'!")

rp.AddTerm("SPP_NotEnoughPatrons", "В принтере недостаточно патрон!")
rp.AddTerm("SPP_TooFar", "Вы слишком далеко от принтера!")
rp.AddTerm("SPP_MaxArmor", "Вы достигли максимального количества брони.")
rp.AddTerm("SPP_MaxHealth", "Вы не нуждаетесь в лечении.")

rp.AddTerm("Vendor_err", "Ошибка! Укажите индекс нужного вам VendorNPC в качестве аргумента!")
rp.AddTerm("Vendor_errind", "Введите числовой индекс (от 1 до #)!")
rp.AddTerm("Vendor_invind", "Вендора с индексом №# не существует! Выберите цифру от 1 до #!")
rp.AddTerm("Vendor_tele", "Вы были телепортированны к Вендору '#'!")
rp.AddTerm("Vendor_far", "Вы слишком далеко!")
rp.AddTerm("Vendor_noitem", "Этот торговец не продает предмет с `#`!")
rp.AddTerm("Vendor_cantbuy", "Этот предмет нельзя купить!")
rp.AddTerm("Vendor_max", "Вы достигли максимума!")
rp.AddTerm("Vendor_cantpay", "Вы не можете себе этого позволить!")
rp.AddTerm("Vendor_noplace", "В вашем инвентаре нет места!")
rp.AddTerm("Vendor_bought", "Вы купили #шт `#` за #")
rp.AddTerm("Vendor_bought2", "Вы купили #шт #")
rp.AddTerm("Vendor_cantsell", "Этот предмет нельзя продать!")
rp.AddTerm("Vendor_cfgerr", "Ошибка конфигурации `#`! Свяжитесь с менеджером/куратором!")
rp.AddTerm("Vendor_nenough", "В вашем ивентаре нет такого количества `#`!")
rp.AddTerm("Vendor_sold", "Вы продали #шт `#` за #")
rp.AddTerm("Vendor_sold_minus", "Вы продали #шт `#` за # (За вычетом #%)")
rp.AddTerm("Vendor_outofstock", "У торговца закончился этот предмет!")

rp.AddTerm('CarOwnerAdded', '# получил ключи от вашей машины.')
rp.AddTerm('CarOwnerAddedYou', '# дал вам ключи от машины.')
rp.AddTerm('CarOwnerRemoved', '# лишён ключей от вашей машины.')
rp.AddTerm('CarOwnerRemovedYou', '# забрал у вас ключи от машины.')
rp.AddTerm('CarOwnerEjectedYou', '# выгнал вас из машины.')

rp.AddTerm('SkillUsed', 'Вы использовали #! (#)')
rp.AddTerm('AbilityCooldown', 'Способность перезаряжается!')
rp.AddTerm('AbilityCantUse', 'Бонус недоступен, #!')
rp.AddTerm('AbilityNotEnoughHours', 'Бонус недоступен, отыграно слишком мало времени!')
rp.AddTerm('AbilityVIP', 'Бонус доступен только для VIP!')

rp.AddTerm( "TransferInvalidDistance", "Расстояние между Вами и целью должна быть не больше 10 метров." );

ba.AddTerm('SyncHoursAdd', '# получил # часов за игру на #!')

rp.AddTerm('SurviveMultiplayer', 'Вы живете уже # минут, получение времени ускорено на #%!')
rp.AddTerm('NightMultiplayer', 'Ночью получение времени ускорено на #%! (ещё # минут)')
rp.AddTerm('NightMultiplayerAll', 'Ночью получение времени ускорено на #%! (ещё #)')
rp.AddTerm('SetGlobalTimeMultiplayer', 'Общее получение времени ускорено на #% на # минут!')
rp.AddTerm('ResetGlobalTimeMultiplayer', 'Общее получение времени снова обычное')
rp.AddTerm('CantCreateTimeMultiplayer', 'Множитель времени не может быть меньше 10% или больше 2000%')

rp.AddTerm( "NotYourCar", "Это не Ваше транспортное средство." );
rp.AddTerm( "FarAwayFromCar", "Вы находитесь слишком далеко от Вашего транспортного средства." );

rp.AddTerm('ProcessingPleaseWait', 'Действие в обработке, пожалуйста, подождите!')
rp.AddTerm('YouAlreadyUsedPromocode', 'Вы уже использовали этот промокод!')
rp.AddTerm('PromocodeActivated', 'Вы активировали промокод # и получили #!')
rp.AddTerm('PromocodeNotFound', 'Промокод не найден!')
rp.AddTerm("PromocodeNewbieERR", "Вы уже использовали промокод для новичков!")
rp.AddTerm('TechError', 'Техническая ошибка, свяжитесь с администрацией для исправления!')
rp.AddTerm('PromocodeTimeLimited', 'Вы наиграли более #! Этот промокод для вас недоступен!')
rp.AddTerm('PromocodeNotAvailable4u', 'Промокод не доступен для вас! #')
rp.AddTerm('PromoFailUsecount', 'Количество активаций промокода истекло')
rp.AddTerm('PromoFailExpired', 'Данный промокод более недействителен')

rp.AddTerm('ConjunctionChanged', 'Отношения между # и # сменились на: #')
rp.AddTerm('ConjunctionCantCapture', 'Вы не можете напасть на союзную точку!')
rp.AddTerm('ConjunctionTooEarly', 'Подождите # секунд, прежде чем менять отношения')
rp.AddTerm('ConjunctionRequest', 'Запрос отправлен дипломату #')
rp.AddTerm('ConjunctionDecline', '# отказались менять отношения')
rp.AddTerm('ConjunctionInvalid', 'Ошибка смены отношений: #')

rp.AddTerm('Capture.WrongJob', 'Ваша профессия не может участвовать в захвате территории!')
rp.AddTerm('Capture.WrongRank', 'Администрация не может участвовать в захвате территории!')
rp.AddTerm('CaptureRewardsBox.Fail', 'Вы не можете брать бонусы чужой территории!')
rp.AddTerm('CaptureRewardsBox.Wait', 'Подождите # секунд, прежде чем взять бонусы снова.')
rp.AddTerm('CaptureRewardsBox.GiveAmmos', 'Получено х# боеприпасов')
rp.AddTerm('CaptureRewardsBox.GiveWeapon', 'Получено оружие #')
rp.AddTerm('CaptureRewardsBox.GiveMoney', 'Получено #')
rp.AddTerm('CaptureRewardsBox.GiveArmor', 'Получено # брони')
rp.AddTerm('PointWasGiven', "Территория '#' была передана #!")

rp.AddTerm("ThisIsMayorImunnity", "Неприкосновенность Мэра! Подождите ещё # сек!")

rp.AddTerm('DonateInProgress', "Подождите, пока обработается покупка...")

rp.AddTerm('HasFired', "# уволил # за #.")
rp.AddTerm('HasKickedFromFaction', "# выгнал # из фракции за #")
rp.AddTerm('HasDemoted', "# понизил # за #")
rp.AddTerm('RewardReceivedBy', "Вы получили премию в размере # от # за #.")
rp.AddTerm('RewardGivenBy', "Вы выдали премию # в размере # за #.")
rp.AddTerm('RewardCooldown', "Вы не можете выдавать премию следующие # секунд.")
rp.AddTerm('TargerHasRewardCooldown', "Игрок уже недавно получал премию, подождите # секунд перед выдачей новой.")
rp.AddTerm('DemoteCooldown', "Подождите # секунд перед следующим увольнением.")
rp.AddTerm('FactionDemote', "Вас выгнали из этой фракции, необходимо подождать # секунд.")
rp.AddTerm('WrongReason', "Причина должна быть от 3 до 20 символов!")

rp.AddTerm('HasRepressed', "# выселил в нежилое пространство # за #")
rp.AddTerm('RepressRequiresCuffs', "Для выселения требуется одеть на жертву наручники!")

rp.AddTerm('ArenaNoPlayers', 'Необходимо минимум трое участников для сражения на Арене.')
rp.AddTerm('ArenaWinner', '# победил в сражении на Арене и получил #!')
rp.AddTerm('ArenaLost', '# выбывает. Осталось # участников.')
rp.AddTerm('ArenaYouLost', 'Вы проиграли в сражении на Арене!')
rp.AddTerm('ArenaStarted', 'Битва на Арене началась!')
rp.AddTerm('ArenaMaxPlayers', 'Достигнуто максимальное количество участников!')

rp.AddTerm( 'EntShop::NotEnoughItems', "У вас недостаточно предметов!" ); 
rp.AddTerm( 'EntShop::Bought', "# купил # '#' за # в вашем магазине!" ); 

rp.AddTerm( 'FoundItems', "Вы нашли # в количестве # шт." ); 
rp.AddTerm( 'PropRepaired', "Вы починили проп и получили #!" ); 

rp.AddTerm( 'WorldLimitReached', "На сервере достигнут лимит #!" ); 
rp.AddTerm( 'EmojiSetup', "Emoji установлен!" ); 

rp.AddTerm( 'NewNyGift', "Вы получили подарок: #!" ); 
rp.AddTerm( 'NewNyGiftCooldown', "Получить подарок можно будет через #" ); 

rp.AddTerm( 'YouCantDisguise', "За данную профессию нельзя маскироваться" );

rp.AddTerm('CfStart', 'Начат краудфандинг на сумму #р. Длительность: # часов.')
rp.AddTerm('CfStop', 'Краудфандинг окончен.')
rp.AddTerm('CfCant', 'Краудфандинг уже запущен.')
rp.AddTerm('CfInvalid', 'Указана невалидная сумма краудфандинга.')

rp.AddTerm( "cpStart", "Акция! #. Длительность: # часов." )
rp.AddTerm( "cpStop", "Акция закончена." )
rp.AddTerm( "cpInProcess", "Акция уже запущена!" )
rp.AddTerm( "cpInvalid", "Акция не валидна." )

rp.AddTerm('Raid::Soon', "Событие-рейд '#' начнётся через #!")
rp.AddTerm('Raid::Start', "Началось событие-рейд '#'!")
rp.AddTerm('Raid::End', "Событие-рейд '#' закончилось")

rp.AddTerm('WantedFaction', '# в розыске вашей фракции. Причина: #, Выдал: #')
rp.AddTerm('WantedStar', '# получил звезду розыска. Причина: #, Выдал: #')
rp.AddTerm('PlayerAlreadyWantedByYou', 'Вы уже подавали в розыск на этого игрока!')
rp.AddTerm('WantedFactionTooManyStars', 'У игрока уже максимум звёзд розыска!')
rp.AddTerm('ArrestedFaction', '# арестован фракцией #')
rp.AddTerm('ArrestedFactionReward', 'Вы получили # за арест преступника!')
rp.AddTerm('KnockedFactionReward', 'Вы получили # за обезвреживание преступника!')

rp.AddTerm('CantWantFaction', "Вы не можете подавать в розыск на игроков из фракции '#'")
rp.AddTerm('CantUnWantFaction', "Вы не можете снимать розыск с игроков из фракции '#'")
rp.AddTerm('CantWantMayor', "Вы не можете подавать в розыск на мэра!")

rp.AddTerm('Lootbox::Reward', "Вы получили '#'!")
rp.AddTerm('Lootbox::AlreadySpawned', "Вы уже заспавнили этот кейс!")
rp.AddTerm('Lootbox::NotYours', "Это не ваш кейс!")
rp.AddTerm( 'Lootbox::InvalidRank', "Вы уже имеете VIP/Админ ранг" ); 
rp.AddTerm( 'Lootbox::InvalidJob', "Вы уже имеете доступ ко всем профессиям из подарка" ); 
rp.AddTerm( 'Lootbox::InvalidTime', "Твоё время уже умножено!" ); 
rp.AddTerm( 'Lootbox::InvalidWep', "Вы уже получили все оружия из данного подарка!" ); 
rp.AddTerm( 'Lootbox::InvalidModel', "Вы уже получили эту модель!" ); 

rp.AddTerm('Factory::InvalidJob', "У вас неподходящая профессия!")
rp.AddTerm('Factory::StorageGot', "Вы получили # за # запасов хранилища!")
rp.AddTerm('Factory::MaxArmor', "У вас уже максимум брони!")
rp.AddTerm('Factory::BadData', "Ошибка данных! Перезайдите на сервер.")
rp.AddTerm('Factory::NoSpace', "В вашем инвентаре нет места!")
rp.AddTerm('Factory::MaxBenefits', "Вы уже приобрели этот предмет.")
rp.AddTerm('Factory::HasWeapon', "У вас уже есть это оружие.")

rp.AddTerm( 'Awards::Reward', "Вы получили #")
rp.AddTerm( 'Awards::InvalidRank', "Вы уже имеете VIP/Админ ранг" ); 
rp.AddTerm( 'Awards::InvalidJob', "Вы уже имеете доступ к этой профессии!" ); 
rp.AddTerm( 'Awards::InvalidTime', "Твоё время уже умножено!" ); 
rp.AddTerm( 'Awards::InvalidWep', "Вы уже получили это оружие!" ); 
rp.AddTerm( 'Awards::InvalidEmotion', "Вы уже получили этот танец!" ); 
rp.AddTerm( 'Awards::InvalidEmoji', "Вы уже получили этот emoji!" ); 
rp.AddTerm( 'Awards::InvalidSalary', "Ваша зарплата уже умножена!" ); 
rp.AddTerm( 'Awards::InvalidModel', "У вас уже есть эта модель!" ); 

rp.AddTerm( 'Seasonpass::QuestCompleted', "Вы завершили задание BATTLE PASS и получили # опыта!" ); 
rp.AddTerm( 'Seasonpass::Rerolled', "Задания BATTLE PASS обновлены!" ); 
ba.AddTerm( 'Seasonpass::GotReward', "# получил награду BATTLE PASS: # " ); 

rp.AddTerm('NpcController::PersonalLoot', "Лут этого NPC принадлежит #!")

rp.AddTerm('CantTieHere', "Вы не можете привязать игрока к этому обьекту")

rp.AddTerm('CantTransferMoreMoney', "Сегодня вы больше не можете передать этому игроку деньги!")
rp.AddTerm('CanTransferOnlyMoney', "Сегодня вы можете передать этому игроку только #!")
rp.AddTerm('CantTransferMoreMoneyAll', "Сегодня вы больше не можете передать деньги!")
rp.AddTerm('CanTransferOnlyMoneyAll', "Сегодня вы можете передать только #!")

rp.AddTerm("JobArmoryPurchased", "Вы купили экипировку # за #!")
rp.AddTerm("JobArmoryEquiped", "Вы экипировали #!")

rp.AddTerm("FakeLoyalty::Choose", "Выберите лояльность, под которую вы будете маскироваться")
rp.AddTerm("FakeLoyalty::Selected", "Выбрана лояльность: #")
rp.AddTerm("FakeLoyalty::Invalid", "Вы уже подменили свою лояльность!")

rp.AddTerm("Destroyable::MarkedNearest", "Ближайший ломаемый предмет был подсвечен")
rp.AddTerm("Destroyable::BreakIt", "Используй монтировку, чтобы сломать этот объект и достать ценные ресурсы")

rp.AddTerm("CantSuicideHandcuffed", "Вы не можете сделать этого в наручниках!")
rp.AddTerm("ConfiscateItemReward", "Вы получили # за конфискацию '#'!")

rp.AddTerm("NotYourRadio", "Вы не можете ставить музыку на чужом радио!")

rp.AddTerm("Jail::SupervisorCant", "Вы не можете сдавать пленных сюда!")
rp.AddTerm("Jail::SupervisorNoPlys", "Нужно вести хотя бы одного пленного в наручниках!")
rp.AddTerm("Jail::SupervisorNoWantedPlys", "Нужно вести хотя бы одного разыскиваемого в наручниках!")
rp.AddTerm("Jail::SupervisorSold", "Вы сдали пленного за #")
rp.AddTerm("Jail::SupervisorYouveBeenSold", "Вас сдали в заключение!")
rp.AddTerm("Jail::DeadSlave", "Пленник уже мёртв!")
rp.AddTerm("Jail::BadSlave", "Вы не можете сдать этого пленного")

rp.AddTerm("AFK::Demoted", "Другой игрок занял вашу профессию, потому что вы были AFK!")

rp.AddTerm("Pets::InvalidData", "Вы не можете вызывать этого питомца")

rp.AddTerm( "HeistWarning", "Внимание! Происходит ограбление Банка!" );
rp.AddTerm( "HeistIsntStarted", "Ограбление не в процессе." );
rp.AddTerm( "AlreadyGotLootbag", "У Вас уже есть сумка." );
rp.AddTerm( "LootbagIsEmpty", "Вы не можете сдать пустую сумку." );
rp.AddTerm( "LootbagIsFull", "Сумка забита до отказа." );
rp.AddTerm( "NotBadLeader", "Вы не являетесь Авторитетом." );
rp.AddTerm( "HeistAlreadyRunning", "Ограбление уже в процессе." );
rp.AddTerm( "HeistLowPolice", "Слишком мало полицейских для старта ограбления. (Необходимо ещё #)" );
rp.AddTerm( "HeistLowBandits", "Слишком мало бандитов для старта ограбления. (Необходимо ещё #)" );
rp.AddTerm( "LootbagReturned", "Вы вернули украденную сумку и получили награду в размере #" );

rp.AddTerm('GunLicenseGot', '# выдал вам лицензию на оружие')
rp.AddTerm('GunLicenseGiven', 'Вы выдали # лицензию на оружие')

rp.AddTerm( "PlySoldWeaponToBuyer", "Вы передали оружие и получили: #." );
rp.AddTerm( "BuyerPurchasedWeaponFromPly", "Вы приняли оружие и получили: #." );

rp.AddTerm( "PetPurchased", "Вы купили питомца # за #." );
