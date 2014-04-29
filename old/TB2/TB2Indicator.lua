TB2Indicator = {}
TB2IndicatorsInRow = 48

function TB2Indicator:OnLoad(frame)
    self.IndFrame = frame
    frame.Tex:SetTexture(1.0, 0.0, 0.0, 1.0);
    self.InvertorStatus = 0;

    self.Frames = {}
    for row= 0,1,1 do
        for i=0,TB2IndicatorsInRow-1,1 do
            ind = CreateFrame("Frame","TB2Indicator"..i,frame,"IndicatorFrameTemplate")
            ind:SetPoint("TOPLEFT",i*5 ,-5*row )
            self.Frames[row*TB2IndicatorsInRow+i] = ind 
        end
    end
    self:ClearControls()
end

function TB2Indicator:Invert()
    if self.InvertorStatus>1 then
        self.InvertorStatus=0
    end
    self.InvertorStatus = self.InvertorStatus+0.05

    self.IndFrame.Invertor.Tex:SetTexture(self.InvertorStatus, self.InvertorStatus, self.InvertorStatus, 1.0);

end


function TB2Indicator:ClearControls()
    for i = 0, TB2IndicatorsInRow*2-1, 1 do
        self.Frames[i].Tex:SetTexture(0.0, 0.0, 0.0, 1.0);
    end
end


function TB2Indicator:CastSpell(i)
    self.Frames[i].Tex:SetTexture(1.0, 1.0, 1.0, 1.0);
end

