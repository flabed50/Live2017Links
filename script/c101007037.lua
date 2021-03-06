--ヴァレルロード・S・ドラゴン
--Borreload Savage Dragon
--Scripted by AlphaKretin
function c101007037.initial_effect(c)
	c:EnableCounterPermit(0x147)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(101007037,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101007037.eqcon)
	e1:SetTarget(c101007037.eqtg)
	e1:SetOperation(c101007037.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,c101007037.eqval,c101007037.equipop,e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007037,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101007037)
	e2:SetCondition(c101007037.discon)
	e2:SetCost(c101007037.discost)
	e2:SetTarget(c101007037.distg)
	e2:SetOperation(c101007037.disop)
	c:RegisterEffect(e2)
end
function c101007037.eqval(ec,c,tp)
	return ec:IsControler(tp) and (ec:GetOriginalType()&TYPE_LINK==TYPE_LINK)
end
function c101007037.filter(c)
	return c:IsType(TYPE_LINK) and not c:IsForbidden()
end
function c101007037.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101007037.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101007037.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c101007037.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,101007037,true) then return end
	local lk=tc:GetLink()
	local atk=tc:GetTextAttack()/2
	if atk<0 then atk=0 end
	if lk>0 then
		c:AddCounter(0x147,lk)
	end
	if atk>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c101007037.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101007037.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		c101007037.equipop(c,e,tp,tc)
	end
end
function c101007037.eqfilter(c)
	return c:GetFlagEffect(101007037)~=0 
end
function c101007037.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c101007037.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x147,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x147,1,REASON_COST)
end
function c101007037.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101007037.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
