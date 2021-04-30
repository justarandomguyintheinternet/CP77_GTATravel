-- Huge thanks to nonamenonumber for creating this <3

mapObserver = {}

function mapObserver.addObservers(gtaTravel)
    local fastTravelScenario
        Observe("MenuScenario_HubMenu", "GetMenusState", function(self)
            if self:IsA("MenuScenario_FastTravel") or self:IsA("MenuScenario_HubMenu") then
                fastTravelScenario = self
            else
                fastTravelScenario = nil
            end
        end)

        Override("gameuiWorldMapMenuGameController", "TryFastTravel", function(self)
            if not gtaTravel.flyPath then
                if self.selectedMappin then
                    gtaTravel.pathing.gtaTravelDestination = self.selectedMappin:GetMappin():GetWorldPosition()
                    if fastTravelScenario and fastTravelScenario:IsA("MenuScenario_FastTravel") then
                        if tostring(self.selectedMappin:GetMappinVariant()) == "gamedataMappinVariant : FastTravelVariant (51)" then
                            gtaTravel.setDirForVector = true
                            fastTravelScenario:GotoIdleState()   
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