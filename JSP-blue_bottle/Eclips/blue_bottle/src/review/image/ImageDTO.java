package review.image;

public class ImageDTO {
	private int review_img_idx;
    private String image_url;
    private int review_idx;
	public int getReview_img_idx() {
		return review_img_idx;
	}
	public void setReview_img_idx(int review_img_idx) {
		this.review_img_idx = review_img_idx;
	}
	public String getImage_url() {
		return image_url;
	}
	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}
	public int getReview_idx() {
		return review_idx;
	}
	public void setReview_idx(int review_idx) {
		this.review_idx = review_idx;
	}
}
