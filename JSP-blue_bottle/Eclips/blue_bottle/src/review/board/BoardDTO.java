package review.board;

import java.sql.Date;

// 리뷰 게시판 DTO
public class BoardDTO {
    private int review_idx;
    private int rating;
    private String title;
    private String content;
    private Date post_date;
    private int visit_count;
    private int user_idx;
    private String product_idx;
    
    // 추가 필드들
    private String username;      // 작성자명
    private String productName;   // 상품명
    
    // 기본 생성자
    public BoardDTO() {}
    
    // Getter, Setter 메소드들
    public int getReview_idx() {
        return review_idx;
    }
    
    public void setReview_idx(int review_idx) {
        this.review_idx = review_idx;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Date getPost_date() {
        return post_date;
    }
    
    public void setPost_date(Date post_date) {
        this.post_date = post_date;
    }
    
    public int getVisit_count() {
        return visit_count;
    }
    
    public void setVisit_count(int visit_count) {
        this.visit_count = visit_count;
    }
    
    public int getUser_idx() {
        return user_idx;
    }
    
    public void setUser_idx(int user_idx) {
        this.user_idx = user_idx;
    }
    
    public String getProduct_idx() {
        return product_idx;
    }
    
    public void setProduct_idx(String product_idx) {
        this.product_idx = product_idx;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    // 별점을 별 모양으로 반환하는 헬퍼 메소드
    public String getStarRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    // 내용을 지정된 길이로 자르는 헬퍼 메소드
    public String getTruncatedContent(int maxLength) {
        if (content != null && content.length() > maxLength) {
            return content.substring(0, maxLength) + "...";
        }
        return content;
    }
}

// 주문 상품 정보 DTO
class OrderProductDTO {
    private int orderIdx;
    private String productIdx;
    private String productName;
    private Date orderDate;
    private int quantity;
    private int price;
    private String reviewed; // Y/N
    
    // 기본 생성자
    public OrderProductDTO() {}
    
    // Getter, Setter 메소드들
    public int getOrderIdx() {
        return orderIdx;
    }
    
    public void setOrderIdx(int orderIdx) {
        this.orderIdx = orderIdx;
    }
    
    public String getProductIdx() {
        return productIdx;
    }
    
    public void setProductIdx(String productIdx) {
        this.productIdx = productIdx;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getPrice() {
        return price;
    }
    
    public void setPrice(int price) {
        this.price = price;
    }
    
    public String getReviewed() {
        return reviewed;
    }
    
    public void setReviewed(String reviewed) {
        this.reviewed = reviewed;
    }
    
    // 리뷰 작성 가능 여부 확인
    public boolean isReviewable() {
        return "N".equals(reviewed);
    }
    
    // 총 금액 계산
    public int getTotalPrice() {
        return price * quantity;
    }
}