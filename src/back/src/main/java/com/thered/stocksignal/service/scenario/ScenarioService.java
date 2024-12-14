package com.thered.stocksignal.service.scenario;

import com.thered.stocksignal.app.dto.ScenarioDto.ConditionRequestDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ConditionResponseDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioRequestDto;
import com.thered.stocksignal.app.dto.ScenarioDto.ScenarioResponseDto;

import java.util.List;


public interface ScenarioService {
    List<ScenarioResponseDto> getScenario(Long userId);

    boolean createScenario(String token, Long userId, ScenarioRequestDto scenarioCreateDto);

    boolean deleteScenario(String token, Long userId, Long scenarioId);

    List<ConditionResponseDto> getConditions(Long userId, Long scenarioId);

    boolean addCondition(Long userId, ConditionRequestDto condtionRequestDto);

    boolean deleteCondition(Long userId, Long conditionId);
}
