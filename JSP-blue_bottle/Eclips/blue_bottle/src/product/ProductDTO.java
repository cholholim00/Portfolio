package product;

public class ProductDTO {
    private String product_idx;
    private String name;
    private int price;
    private int stock;
    private int category_idx;

    public String getProduct_idx() {
        return product_idx;
    }

    public void setProduct_idx(String product_idx) {
        this.product_idx = product_idx;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getCategory_idx() {
        return category_idx;
    }

    public void setCategory_idx(int category_idx) {
        this.category_idx = category_idx;
    }
}
