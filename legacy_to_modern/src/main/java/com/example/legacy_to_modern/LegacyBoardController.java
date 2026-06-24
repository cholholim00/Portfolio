package com.example.legacy_to_modern;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j // 실무 표준 로거 도입
@RestController
@RequestMapping("/api/legacy/board")
public class LegacyBoardController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 1. 게시글 전체 목록 조회 API
    @GetMapping("/list")
    public List<Map<String, Object>> getBoardList() throws Exception {
        log.info("[System Log] 게시판 목록 조회 API 호출");
        String sql = "SELECT * FROM board_legacy ORDER BY id DESC";
        return jdbcTemplate.queryForList(sql);
    }

    // 2. 게시글 상세 조회 API (SQL 인젝션 방어가 완료된 안전한 구조)
    @GetMapping("/{id}")
    public Map<String, Object> getBoardDetail(@PathVariable("id") String id) throws Exception {
        log.info("[System Log] 게시글 상세 조회 API 호출 - 요청 ID: {}", id);

        // 변수가 들어갈 자리를 물음표(?)로 비워두어 해커가 쿼리를 조작하는 것을 원천 차단합니다.
        String secureSql = "SELECT * FROM board_legacy WHERE id = ?";
        return jdbcTemplate.queryForMap(secureSql, id);
    }

    // 3. 게시글 작성 API
    @PostMapping("/write")
    public String writeBoard(@RequestBody Map<String, String> param) throws Exception {
        String title = param.get("title");
        String content = param.get("content");
        String author = param.get("author");

        // (참고) 나중에 고도화 단계에서 이 부분도 물음표(?) 바인딩 방식으로 개선하면 좋습니다!
        String sql = "INSERT INTO board_legacy (title, content, author) VALUES ('" + title + "', '" + content + "', '" + author + "')";
        jdbcTemplate.execute(sql);

        return "success";
    }
}