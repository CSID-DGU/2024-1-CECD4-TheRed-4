package com.thered.stocksignal.repository;

import com.thered.stocksignal.domain.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    Boolean existsByNickname(String nickname);

    Optional<User> findById(Long id);
}
