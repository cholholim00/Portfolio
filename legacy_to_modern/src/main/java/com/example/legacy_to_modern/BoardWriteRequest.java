package com.example.legacy_to_modern;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

// 클라이언트가 보낸 데이터를 엄격하게 검사하기 위한 전용 방패 역할입니다.
public class BoardWriteRequest {

    @NotBlank(message = "제목은 필수 입력값입니다.")
    @Size(max = 50, message = "제목은 50자를 초과할 수 없습니다.")
    private String title;

    @NotBlank(message = "내용은 비어있을 수 없습니다.")
    private String content;

    @NotBlank(message = "작성자 이름이 누락되었습니다.")
    @Size(max = 20, message = "작성자 이름은 20자를 초과할 수 없습니다.")
    private String author;

    // Getter와 Setter
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
}