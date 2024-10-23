package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.Scenario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ScenarioRepository extends JpaRepository<Scenario, Long> {

    List<Scenario> findByUserId(Long userId);

    Optional<Scenario> findByIdAndUserId(Long id, Long userId);
}
