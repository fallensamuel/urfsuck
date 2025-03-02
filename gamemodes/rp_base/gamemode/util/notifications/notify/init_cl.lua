-- "gamemodes\\rp_base\\gamemode\\util\\notifications\\notify\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net( "rp.NotifyString", function()
	notification.AddLegacy( rp.ReadMsg(), net.ReadUInt(2), 4 );
end );

net( "rp.NotifyTerm", function()
	local term = rp.ReadTerm();
	
	if term then
		notification.AddLegacy( term, net.ReadUInt(2), 4 );
	end
end );


----------------------------------------------------------------
-- rp.Notify:
----------------------------------------------------------------
function rp.Notify(notify_type, msg, ...)
	local replace = {...}
	local count = 0

	if isnumber(msg) then
		msg = rp.Terms[msg]
	end
	
	msg = msg:gsub('#', function()
		count = count + 1
		local v = replace[count]
		local t = type(v)

		if (t == 'Player') then
			if (not IsValid(v)) then return 'Unknown' end

			return v:Name()
		elseif (t == 'Entity') then
			if (not IsValid(v)) then return 'Invalid Entity' end

			return (v.PrintName and v.PrintName or v:GetClass())
		end

		return v
	end)

	notification.AddLegacy(msg, notify_type, 4)
end


----------------------------------------------------------------
-- rp.NotifyTerm:
----------------------------------------------------------------
function rp.NotifyTerm(type, term, ...)
	rp.Notify(type, rp.GetTerm(term), ...)
end


----------------------------------------------------------------
-- rp.ReminderNotifies:
----------------------------------------------------------------
rp.ReminderNotifies = rp.ReminderNotifies or {
    List = {}, Queue = {}
};

for _, ReminderNotify in pairs( rp.ReminderNotifies.List ) do
    if ReminderNotify.tid then
        timer.Remove( ReminderNotify.tid );
    end
end

rp.ReminderNotifies.List = {};
rp.ReminderNotifies.Initialized = nil;

rp.NotifyReminder = function( message, typ, length, delay, reps, check )
    if type( message ) ~= "function" then
        local _message = message;
        message = function( ply )
            return _message;
        end
    end

    typ    = typ or NOTIFY_GENERIC;
    length = math.max( 1, tonumber(length) or 1 );
    delay  = math.max( 1, tonumber(delay) or 1 );
    reps   = math.max( 0, tonumber(reps) or 1 );

    if type( check ) ~= "function" then
        local _check = tobool( check );
        check = function( ply )
            return check;
        end
    end

    local CReminderNotify = {};

    CReminderNotify.Message = message;
    CReminderNotify.Type    = typ;
    CReminderNotify.Length  = length;
    CReminderNotify.Delay   = delay;
    CReminderNotify.Reps    = reps;
    CReminderNotify.Check   = check;
    CReminderNotify.id      = table.insert( rp.ReminderNotifies.List, CReminderNotify );
    
    table.insert( rp.ReminderNotifies.Queue, CReminderNotify.id );
    return CReminderNotify.id;
end

rp.RemoveNotifyReminder = function( id )
    local ReminderNotify = rp.ReminderNotifies.List[id];
    if not ReminderNotify then return end

    if ReminderNotify.tid and timer.Exists( ReminderNotify.tid ) then
        timer.Remove( ReminderNotify.tid );
    end

    rp.ReminderNotifies.List[id] = nil;
end

hook.Add( "CreateMove", "rp.ReminderNotifies::Initialize", function( cmd )
    if (cmd:GetButtons() > 0) then
        hook.Remove( "CreateMove", "rp.ReminderNotifies::Initialize" );
        rp.ReminderNotifies.Initialized = true;
    end
end );

hook.Add( "PreDrawHUD", "rp.ReminderNotifies::QueueHandler", function()
    if not rp.ReminderNotifies.Initialized then return end
    if #rp.ReminderNotifies.Queue == 0 then return end

    local LocalPly = LocalPlayer();

    for _, rnid in ipairs( rp.ReminderNotifies.Queue ) do
        local ReminderNotify = rp.ReminderNotifies.List[rnid];
        if not ReminderNotify then continue end

        if ReminderNotify.tid then continue end
        ReminderNotify.tid = "ReminderNotify-" .. ReminderNotify.id;

        local function ReminderNotifyTimer()
            local Check, CheckData = ReminderNotify.Check( LocalPly );
            if not Check then
                if ReminderNotify.Reps > 0 then
                    timer.Adjust( ReminderNotify.tid, ReminderNotify.Delay, timer.RepsLeft(ReminderNotify.tid) + 1 );
                end

                return
            end

            notification.AddLegacy( tostring( ReminderNotify.Message(LocalPly, CheckData) ), ReminderNotify.Type, ReminderNotify.Length );
        end 

        ReminderNotifyTimer();
        
        if (ReminderNotify.Reps > 1) then
            timer.Create( ReminderNotify.tid, ReminderNotify.Delay, ReminderNotify.Reps - 1, ReminderNotifyTimer );
        elseif (ReminderNotify.Reps == 0) then
            timer.Create( ReminderNotify.tid, ReminderNotify.Delay, ReminderNotify.Reps, ReminderNotifyTimer );
        end
    end

    rp.ReminderNotifies.Queue = {};
end );