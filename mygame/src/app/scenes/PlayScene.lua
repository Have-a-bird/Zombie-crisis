
local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

local socket = require "socket"

function PlayScene:ctor()
	
		y =	1	--	换枪初始值
		x = 8
		self.chucun = {}
		self.huoyan ={}
		self.bullet2 = {}
		self:chumo()
		
		self:Bunker(x)
		self:bianjie()
		self:wutai()	
		self:anjian()

		self.ZBiao = cc.p(display.cx, 300)
		self.isTouched = false
		self.isAutoMode = false
		self.lastShootTime = 0
----节点调度器------
	self.abc = self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
		-- 手动模式下，未触摸，直接进去下一帧的循环
		if false == self.isAutoMode and false == self.isTouched then
			return
		end

		if (socket.gettime() - self.lastShootTime > 0.28) then
			if self.ZBiao.y >= (display.cy - 150) then
				local angle = math.atan((self.ZBiao.y-(display.cy-200)) / (self.ZBiao.x - display.cx))
				local rotation = math.radian2angle(angle)
					if rotation < 0 then
						rotation = rotation + 180
					end
				self.sprite2:setRotation(90 - rotation)
				----火焰----
				self:Wifre(y)
				local  wfire = self:genWifre()										
					wfire:pos(35,display.cy-90)
					self.sprite2:addChild(wfire)
				local move1 =cc.MoveTo:create(0.2,cc.p(35,display.cy-90))
				local callBack1 = cc.CallFunc:create(function() 
					wfire:removeFromParent()
					wfire = nil 
				end)
				local action1 = cc.Sequence:create(move1,callBack1) 
					wfire:runAction(action1)
				----子弹---
				self:Bullet(y)
				local bullet = self:genBullet()
				local R = math.sqrt(400^2+440^2)
					X = R * math.sin(math.angle2radian(90-rotation))
					Y = R * math.cos(math.angle2radian(90-rotation))
				offsetX = (160) * math.sin(math.angle2radian(90-rotation))
				offsetY = (160) * math.cos(math.angle2radian(90-rotation))
					bullet:pos(offsetX+(400),offsetY+20)
					:addTo(self)											
				local move = cc.MoveTo:create(1.2,cc.p(X+(400),Y+20))
				local callBack = cc.CallFunc:create(function() 
					bullet:removeFromParent()
					bullet = nil
				end)
				local action = cc.Sequence:create(move, callBack)
				bullet:runAction(action)
				bullet : setRotation(90 - rotation)

				self.lastShootTime = socket.gettime()
			end
		end
	end)
	self:scheduleUpdate()
end
	-- 炮台
function PlayScene:wutai()
	display.addSpriteFrames("PlistImage/hero.plist","PlistImage/hero.png")
	
	self.sprite2 = display.newSprite("#leg.png")													----裤----
		:pos(display.cx,display.cy-220)
		:addTo(self,1)

	display.addSpriteFrames("PlistImage/gunAndBullets.plist","PlistImage/gunAndBullets.png")

	self.sprite = display.newSprite("#weapon_1.png")												----枪----
		:pos(35,display.cy-154)
		self.sprite2:addChild(self.sprite)

	display.addSpriteFrames("PlistImage/hero.plist","PlistImage/hero.png")							----人----
	local frames = display.newFrames("body_1%d.png",1,3)
	local animation = display.newAnimation(frames,0.2)
	local animate = cc.Animate:create(animation)
	local sprite1 = display.newSprite("#body_2" ..  ".png")
		:center()
		:pos(35,display.cy-180)
		self.sprite2:addChild(sprite1)
		sprite1:runAction(cc.RepeatForever:create(animate))
end
	-- 按键
function PlayScene:anjian()
		--  右键
	local image = {
		normal = "standard/changeGunReady_right.png",	
		pressed = "standard/changeGunPress_right.png",
	}
	cc.ui.UIPushButton.new(image,{scale9 = false})
		:onButtonClicked(function(event)
			y = y + 1 
			-- t = y
			if y > 16 then
				y =1
			end
			self:gun(y)
			self:Bullet(y)
			self:Wifre(y)
			self:qang(y)
		end)
		:align(display.CENTER,display.cx+78,display.cy-207)
		:addTo(self,2)

		--	左键
	local image = {
		normal = "standard/changeGunReady_left.png",
		pressed = "standard/changeGunPress_left.png",
	}
	cc.ui.UIPushButton.new(image,{scale9 = false})
		:onButtonClicked(function(event)
		
			y = y-1
			if y == 0 then
				y = 16
			end	
			self:gun(y)
			self:Bullet(y)
			self:Wifre(y)
			self:qang(y)
		end)
		:align(display.CENTER,display.cx-90,display.cy-207)
		:addTo(self,2)

end
	-- 围墙升级
function PlayScene:Bunker(x)
	display.addSpriteFrames("PlistImage/bunker.plist","PlistImage/bunker.png")
	if x <= 3 then
		local f = display.newSprite("#bunker.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x <= 6 then
		local f = display.newSprite("#bunker1.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x <= 9 then
		local f = display.newSprite("#bunker2.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x <= 12 then
		local f = display.newSprite("#bunker3.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x <= 15 then
		local f = display.newSprite("#bunker4.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x <= 18 then
		local f = display.newSprite("#bunker5.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)
	elseif x ==	19 then
		local f = display.newSprite("#bunkerSpike.png")
			:pos(display.cx,display.cy-174)
			:addTo(self)
		local f1 = display.newSprite("#bunker5.png")
			:pos(display.cx,display.cy-184)
			:addTo(self)

	end	
end

function PlayScene:chumo()

	self.abc =	display.newSprite("map/image/map1_main.jpg")
			:pos(display.cx,display.cy)
			:addTo(self)

	self.abc:setTouchEnabled(true)
	self.abc:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		self.ZBiao = cc.p(event.x,event.y)
		if event.name == "began" then
			self.isTouched = true
			return true
		end
		if event.name == "moved" then
			local bcd = cc.ParticleSystemQuad:create("particle/mouse/mouse.plist")
			local batch = cc.ParticleBatchNode:createWithTexture(bcd:getTexture())
				batch:addChild(bcd)
				self:addChild(batch,10)
				bcd:setPosition(event.x,event.y)
		end
		if event.name =="ended" then
			self.isTouched = false
		end
	end)
end

	-- 枪
function PlayScene:gun(y)
	local frame = display.newSpriteFrame("weapon_" ..y.. ".png")
	self.sprite:setSpriteFrame(frame)
end
	-- 子弹
function PlayScene:Bullet(y)

	self.mBulletType = y
end
	-- 子弹升级
function PlayScene:genBullet()
	display.addSpriteFrames("PlistImage/gunAndBullets.plist","PlistImage/gunAndBullets.png")

	local bullet1 = display.newSprite("#bullet_" ..self.mBulletType.. ".png")
	return bullet1
end
	-- 火焰
function PlayScene:Wifre(y)
	if y ==2 then
		y = 1
	elseif y > 6 and y < 10 then
		y = 6
	elseif y == 14 then
		y = 10
	end
	self.mWifreType = y
end
	-- 火焰升级
function PlayScene:genWifre()
	display.addSpriteFrames("PlistImage/gunAndBullets.plist","PlistImage/gunAndBullets.png")
	local wfire1 = display.newSprite("#wfire_" ..self.mWifreType.. ".png")
	return wfire1
end
	-- 边界优化
function PlayScene:bianjie()
	display.newSprite("standard/buttomBg.png")
		:pos(display.cx,display.cy-200)
		:addTo(self,2)
	----枪图标变化----
	display.addSpriteFrames("weaponSmall.plist","weaponSmall.png")
	self.Hqang1 = display.newSprite("#weaponSmall1.png")
		:pos(display.cx+152,display.cy-208)
		:addTo(self,2)
	display.newSprite("standard/shopBtPress.png")
		:pos(display.cx+332,display.cy-206)
		:addTo(self,2)
	----自动手动切换----
	local image = {
		on = "standard/auto1.png",
		off = "standard/auto2.png"									
	}
	cc.ui.UICheckBoxButton.new(image)
		:onButtonStateChanged(function(event)
			if event.target:isButtonSelected() then
				self.isAutoMode = true
			else
				self.isAutoMode = false
			end
		end)
		:align(display.CENTER,display.cx+250,display.cy-152)
		:addTo(self)

	----骨动画----
	cachedData = sp.SkeletonData:create("spine/skill1_icon.json","spine/skill1_icon.atlas")
	local spineAnimation = sp.SkeletonAnimation:create(cachedData)
	spineAnimation:pos(display.cx-340,display.cy-225)
	:addTo(self,2)
	:setAnimation(0,"yundong",true)

end
-----枪图标变化y值-----
function PlayScene:qang(y)
	local frame = display.newSpriteFrame("weaponSmall" ..y.. ".png")
	self.Hqang1:setSpriteFrame(frame)

end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene