-- Huge thanks to psiberx for the helping to create this <3

mapObserver = {
    ftDisabled = false
}

function mapObserver.addObservers(gtaTravel)
    local fastTravelScenario
        Observe("MenuScenario_HubMenu", "GetMenusState", function(self)
            if self:IsA("MenuScenario_FastTravel") or self:IsA("MenuScenario_HubMenu") then
                fastTravelScenario = self
            else
                fastTravelScenario = nil
            end
        end)

        Override("WorldMapMenuGameController", "FastTravel", function (this)
            if not mapObserver.ftDisabled then
                if not this:IsFastTravelEnabled() then return end

                local mappin = this.selectedMappin:GetMappin()
                local request = PerformFastTravelRequest.new()
                request.pointData = mappin:GetPointData()
                request.player = Game.GetPlayer()
                this:GetFastTravelSystem():QueueRequest(request)
                local nextLoadingTypeEvt = inkSetNextLoadingScreenEvent.new()
                nextLoadingTypeEvt:SetNextLoadingScreenType(inkLoadingScreenType.FastTravel)
                this:QueueBroadcastEvent(nextLoadingTypeEvt)
                fastTravelScenario:GotoIdleState()
            else
                mapObserver.ftDisabled = false
            end
        end)

        Observe("gameuiWorldMapMenuGameController", "TryFastTravel", function(self)
            if not gtaTravel.flyPath and not gtaTravel.api.modBlocked then
                if self.selectedMappin then
                    gtaTravel.pathing.gtaTravelDestination = self.selectedMappin:GetMappin():GetWorldPosition()
                    if fastTravelScenario and fastTravelScenario:IsA("MenuScenario_FastTravel") then
                        if tostring(self.selectedMappin:GetMappinVariant()) == "gamedataMappinVariant : FastTravelVariant (51)" then
                            gtaTravel.setDirForVector = true
                            fastTravelScenario:GotoIdleState()
                            mapObserver.ftDisabled = true
                        end
                    end
                    if fastTravelScenario and fastTravelScenario:IsA("MenuScenario_HubMenu") then
                        if not gtaTravel.settings.miscSettings.ftp2ftp then
                            if gtaTravel.settings.miscSettings.anywhere2ftp then
                                if tostring(self.selectedMappin:GetMappinVariant()) == "gamedataMappinVariant : FastTravelVariant (51)" then
                                    gtaTravel.setDirForVector = true
                                    fastTravelScenario:GotoIdleState()
                                    fastTravelScenario:GotoIdleState()
                                end
                            elseif gtaTravel.settings.miscSettings.anywhere2anywhere then
                                gtaTravel.setDirForVector = true
                                fastTravelScenario:GotoIdleState()
                                fastTravelScenario:GotoIdleState()
                            end
                        end
                    end
                    self:PlaySound("MapPin", "OnCreate", "")
                end
            end
        end)
end

return mapObserver