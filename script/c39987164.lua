--ヴァイロン・ディシグマ
function c39987164.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39987164,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c39987164.eqcost)
	e1:SetTarget(c39987164.eqtg)
	e1:SetOperation(c39987164.eqop)
	c:RegisterEffect(e1,false,1)
	aux.AddEREquipLimit(c,nil,c39987164.eqval,c39987164.equipop,e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39987164,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c39987164.descon)
	e2:SetTarget(c39987164.destg)
	e2:SetOperation(c39987164.desop)
	c:RegisterEffect(e2)
end
function c39987164.eqval(ec,c,tp)
	return ec:IsControler(1-tp) and ec:IsAttackPos() and ec:IsType(TYPE_EFFECT)
end
function c39987164.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c39987164.filter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c39987164.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c39987164.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c39987164.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c39987164.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c39987164.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,39987164)
end
function c39987164.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c39987164.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c39987164.desfilter(c,att)
	return c:GetFlagEffect(39987164)~=0 and c:IsAttribute(att)
end
function c39987164.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dt=Duel.GetAttacker()
	if dt==c then dt=Duel.GetAttackTarget() end
	if not dt or dt:IsFacedown() then return false end
	e:SetLabelObject(dt)
	local att=dt:GetAttribute()
	return c:GetEquipGroup():IsExists(c39987164.desfilter,1,nil,att)
end
function c39987164.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c39987164.desop(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabelObject()
	if dt:IsRelateToBattle() then
		Duel.Destroy(dt,REASON_EFFECT)
	end
end
