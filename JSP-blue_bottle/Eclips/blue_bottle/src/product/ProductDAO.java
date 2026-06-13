package product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;


public class ProductDAO extends JDBConnect{
    public ProductDAO() {}

    // 전체 상품 조회
    public List<ProductDTO> getAllProducts() {
        List<ProductDTO> productList = new ArrayList<>();
        String sql = "SELECT * FROM product";

        try {
            pstmt = getConnection().prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setProduct_idx(rs.getString("product_idx"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getInt("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_idx(rs.getInt("category_idx"));
                productList.add(product);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productList;
    }

    // product_idx로 상품 1개 가져오기
    public ProductDTO getProductById(String product_idx) {
        ProductDTO product = null;
        String sql = "SELECT * FROM product WHERE product_idx = ?";

        try {
            pstmt = getConnection().prepareStatement(sql);
            pstmt.setString(1, product_idx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                product = new ProductDTO();
                product.setProduct_idx(rs.getString("product_idx"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getInt("price"));
                product.setStock(rs.getInt("stock"));
                product.setCategory_idx(rs.getInt("category_idx"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }
}
