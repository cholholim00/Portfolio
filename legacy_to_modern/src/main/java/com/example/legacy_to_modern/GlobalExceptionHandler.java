package com.example.legacy_to_modern;

import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@ControllerAdvice // 프로젝트 전역의 에러 명찰은 오직 이 클래스 위에만 붙입니다.
public class GlobalExceptionHandler {

    // 1. 데이터가 없을 때 발생하는 에러 캐치 (404 예방 전선)
    @ExceptionHandler(EmptyResultDataAccessException.class)
    public ResponseEntity<Map<String, String>> handleEmptyResultException(EmptyResultDataAccessException e) {
        log.error("[Error] 존재하지 않는 데이터 조회 시도: {}", e.getMessage());

        Map<String, String> response = new HashMap<>();
        response.put("status", "404");
        response.put("message", "요청하신 데이터를 찾을 수 없습니다.");

        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    // 2. 그 외 모든 백엔드 런타임 예외 방어 (500 최후의 보루)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleGeneralException(Exception e) {
        log.error("[Fatal Error] 시스템 내부 오류 발생: ", e);

        Map<String, String> response = new HashMap<>();
        response.put("status", "500");
        response.put("message", "시스템 점검 중입니다. 관리자에게 문의하세요.");

        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}