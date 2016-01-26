
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)


function MainScene:ctor()

	self.Gold = 0		----金币数量初始化----

	self.Diamonds = 0
	
	self.beijin=display.newSprite("shop/background.jpg")
	:pos(display.cx,display.cy)
	:addTo(self)
	self:UI()

end

	----装备界面----
function MainScene:UI()
	
	----返回----
	local images = {
		normal = "shop/btnReturn.png",
		pressed = "shop/btnReturnPress.png",										
	}

	cc.ui.UIPushButton.new(images,{scale9 = false})
		:onButtonClicked(function(event)
		-- local playScene = import("app.scenes.PalyScene"):new()
		-- display.replaceScene(playScene,"rotoZoom",0.5)
		end)
		:align(display.CENTER,display.cx-360,display.cy+200)
		:addTo(self)
	
	----升级----
	local image1 = {
			on = "shop/tagUpgrade.png",
			off = "shop/tagUpgradeSelect.png"										
		}

	local function updateCheckBoxButtonLable(checkbox)
		local state = ""
		if checkbox:isButtonSelected() then
				state = "on"
			else
				state = "off"
			end
		if not checkbox:isButtonEnabled() then
				state = state .. "(on)"
		-- elseif  state == "off" then
		-- 		self:UI1()
		end
		checkbox:setButtonLabelString(string.format("state is %s",state))
	end

	local checkBoxButton1=cc.ui.UICheckBoxButton.new(image1)

	
		:onButtonStateChanged(function(event)
			updateCheckBoxButtonLable(event.target)
		end)
		:align(display.CENTER,display.cx-260,display.cy+200)
		:addTo(self)
		updateCheckBoxButtonLable(checkBoxButton1)
	----装备----
	local image = {
		on = "shop/tagEquipment.png",
		off = "shop/tagEquipmentSelect.png"												
		}

		checkBoxButton1:setButtonSelected(true)
	local function updateCheckBoxButtonLable(checkbox)
		local state = ""
		if checkbox:isButtonSelected() then
			state = "on"
		else
			state = "off"
		end
		if not checkbox:isButtonEnabled() then
			state = state .. "(on)"
		end
		checkbox:setButtonLabelString(string.format("state is %s",state))
	end

	local checkBoxButton2=cc.ui.UICheckBoxButton.new(image)
		:onButtonStateChanged(function(event)
			updateCheckBoxButtonLable(event.target)

		end)
		:align(display.CENTER,display.cx-140,display.cy+200)
		:addTo(self)
		updateCheckBoxButtonLable(checkBoxButton2)

	----金币和钻石槽----	
	display.newSprite("shop/goldJewelBg.png")
		:pos(display.cx+150,display.cy+200)
		:addTo(self)
	
	----金币图标----
	display.newSprite("addGold.png")
		:pos(display.cx+140,display.cy+200)
		:addTo(self)
	
	----钻石图标----
	display.newSprite("addMoney.png")
		:pos(display.cx+310,display.cy+200)
		:addTo(self)
	
	----金币数量----
	self.GoldLabel = cc.ui.UILabel.new({UILabelType =1,text = tostring(self.Gold),				
		font = "shop/game/zi.fnt"})
		:align(display.CENTER, display.cx+90,display.cy+200)
		:addTo(self)
	
	----钻石数量----
	self.DiamondsLabel = cc.ui.UILabel.new({UILabelType =1,text = tostring(self.Diamonds),			
		font = "shop/upgrade/DiamondText.fnt"})
		:align(display.CENTER, display.cx+260,display.cy+200)
		:addTo(self)
	
	----枪底色----
	display.newSprite("shop/weapon/BigArrtibuteBg.png")												
		:pos(display.cx+128,display.cy)
		:addTo(self)
	-- display.newSprite("shop/weapon/ScrollBg.png")
	-- 	:align(display.CENTER,display.cx-180,display.cy)
	-- 	:addTo(self)
	------滑动条------
	local image2 = {
		bar = "shop/weapon/ScrollBg.png",
		button = "shop/weapon/ScrollCap.png",
	}

	--竖直滑动条
	local barHeight = 310
	local barWidth = 32
	-- local valueLabel = cc.ui.UILabel.new({text = "",size = 14,color = display.COLOR_BLACK})
	-- 	:align(display.LEFT_CENTER,display.cx,display.cy)
	-- 	:addTo(self)
	cc.ui.UISlider.new(display.TOP_TO_BOTTOM,image2,{scale9 = true})
		:onSliderValueChanged(function(event)
			-- valueLabel:setString(string.format("value = %0.2f",event.value))
			print(event.name)
			-- self.lv:scrollTo()
		end)
		:onSliderStateChanged(function(event)
			print(event.name)
		end)
		:onSliderPressed(function(event)
			print(event.name)
		end)
		:onSliderRelease(function(event)
			print(event.name)
		end)
		:setSliderSize(barWidth, barHeight)
		:setSliderValue(10)
		:align(display.CENTER,display.cx-180,display.cy)
		:addTo(self)
	
	------列表------
	display.addSpriteFrames("weaponSmall.plist","weaponSmall.png")
	self.lv = cc.ui.UIListView.new{
		bgColor = nil,
		bgScale9 = false,
		viewRect  = cc.rect(10,140,120,220),
		direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
		scrollbarImgV = nil,
	}
		:addTo(self.beijin)
		
		self.lv:onTouch(function(event) 
				if event.name == "moved" then
				end
			end)
		for i = 1,16 do
			local sprite = display.newSprite("#weaponSmall"..i..".png")
			local item = self.lv:newItem()
				item:setItemSize(220, 132, true)----设置列表项的大小，垂直翻滚看y，水平翻滚看x
    			item:addContent(sprite)------将滚动的图片添加到列表项上面
    			self.lv:addItem(item)-------添加列表项到列表视图	
    		local sprite1 = display.newSprite("shop/weapon/dLine.png")
        		:pos(display.cx-300,display.cy+2112-i*132)
        		:addTo(self.beijin)	
    		end
     			
    			self.lv:reload()-----重新加载
    		
     -- 	for i=1, 16 do
     		
    	-- end

   	display.newSprite("shop/weapon/currentWeaponBg.png")
		:align(display.CENTER,display.cx,display.cy-200)
		:addTo(self)
	
	----开始游戏----
    local image5 = {
		normal = "shop/btnStartEu.png",
		pressed = "shop/btnStartEuPress.png",										
	}

	cc.ui.UIPushButton.new(image5,{scale9 = false})
		:onButtonClicked(function(event)
		local playScene = import("app.scenes.PlayScene"):new()
		display.replaceScene(playScene,"rotoZoom",0.5)
		end)
		:align(display.CENTER,display.cx+300,display.cy-205)
		:addTo(self)

	display.newSprite("weaponSmall1.png")
		:align(display.CENTER,display.cx-320,display.cy-205)
		:addTo(self)
end


	----升级界面----
function MainScene:UI1()
		local images = {
		normal = "shop/btnReturn.png",
		pressed = "shop/btnReturnPress.png",
	}

	cc.ui.UIPushButton.new(images,{scale9 = false})
		:onButtonClicked(function(event)
		end)
		:align(display.CENTER,display.cx-360,display.cy+200)
		:addTo(self)

	local image = {
		off = "shop/tagEquipment.png",
		off_pressed = "shop/tagEquipmentSelect.png"											----装备----
	}

	cc.ui.UICheckBoxButton.new(image)
		:onButtonClicked(function(event)
		end)
		:align(display.CENTER,display.cx-140,display.cy+200)
		:addTo(self)

	local image1 = {
		on = "shop/tagUpgrade.png",
		off = "shop/tagUpgradeSelect.png"													----升级----
	}

	local function updateCheckBoxButtonLable(checkbox)
		local state = ""
		if checkbox:isButtonSelected() then
			state = "on"
		else
			state = "off"

	
		end
		if not checkbox:isButtonEnabled() then
			state = state .. "(off)"
		end
		checkbox:setButtonLabelString(string.format("state is %s",state))
	end

	local checkBoxButton1=cc.ui.UICheckBoxButton.new(image1)

	
		:onButtonStateChanged(function(event)
			updateCheckBoxButtonLable(event.target)

		end)
		:align(display.CENTER,display.cx-260,display.cy+200)
		:addTo(self)
		updateCheckBoxButtonLable(checkBoxButton1)


end


function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
