package com.thered.stocksignal.service.scenario;

import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioRequestDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioResponseDto;

import java.util.List;


public interface ScenarioService {
    List<ScenarioResponseDto> getScenario(Long userId);

    boolean createScenario(Long userId, ScenarioRequestDto scenarioCreateDto);
}
