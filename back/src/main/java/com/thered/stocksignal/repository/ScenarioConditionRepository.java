package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.Scenario;
import com.thered.stocksignal.domain.entity.ScenarioCondition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ScenarioConditionRepository extends JpaRepository<ScenarioCondition, Long> {
    void deleteByScenario(Scenario scenario);

    List<ScenarioCondition> findByScenarioId(Long scenarioId);

}
