-- 기존에 잘못 만들어진 게 있다면 지우고 깔끔하게 새로 만듭니다.
DROP TABLE IF EXISTS board_legacy;

CREATE TABLE board_legacy (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              title VARCHAR(200) NOT NULL,
                              content TEXT,
                              author VARCHAR(50),
                              created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);