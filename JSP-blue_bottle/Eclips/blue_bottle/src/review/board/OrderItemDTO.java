package review.board;

// 주문 아이템 DTO
public class OrderItemDTO {
    private String product_idx;
    private String product_name;
    private int quantity;
    private int unit_price;
    
    // 기본 생성자
    public OrderItemDTO() {}
    
    // Getter, Setter 메소드들
    public String getProduct_idx() {
        return product_idx;
    }
    
    public void setProduct_idx(String product_idx) {
        this.product_idx = product_idx;
    }
    
    public String getProduct_name() {
        return product_name;
    }
    
    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public int getUnit_price() {
        return unit_price;
    }
    
    public void setUnit_price(int unit_price) {
        this.unit_price = unit_price;
    }
    
    // 헬퍼 메소드들
    public String getFormattedPrice() {
        return String.format("%,d", unit_price);
    }
    
    public int getTotalAmount() {
        return unit_price * quantity;
    }
    
    public String getFormattedTotalAmount() {
        return String.format("%,d", getTotalAmount());
    }
}