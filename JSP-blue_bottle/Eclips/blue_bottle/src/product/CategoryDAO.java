package product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class CategoryDAO extends JDBConnect{
	public CategoryDAO () {}


    // 모든 카테고리 조회
    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> categories = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY category_idx";

        try {
            pstmt = getConnection().prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CategoryDTO category = new CategoryDTO();
                category.setCategory_idx(rs.getInt("category_idx"));
                category.setCategory_name(rs.getString("category_name"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
}
