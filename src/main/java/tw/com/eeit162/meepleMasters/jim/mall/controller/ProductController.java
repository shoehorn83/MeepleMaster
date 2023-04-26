package tw.com.eeit162.meepleMasters.jim.mall.controller;

import java.io.BufferedInputStream;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import tw.com.eeit162.meepleMasters.jim.mall.model.bean.Product;
import tw.com.eeit162.meepleMasters.jim.mall.service.ProductService;

@Controller
public class ProductController {

	@Autowired
	private ProductService pService;

	// 依照頁數顯示商品
	@GetMapping("/mall/productList")
	public String productList(@RequestParam(defaultValue = "1") Integer page,
			@RequestParam(defaultValue = "6") Integer count, Model model) {
		Page<Product> productPage = pService.findAllProduct(page, count);

		model.addAttribute("productPage", productPage);

		return "jim/product";
	}

	// 透過ID尋找商品
	@GetMapping("/mall/findProductById")
	@ResponseBody
	public Product findProductById(@RequestParam Integer id) {
		return pService.findProductById(id);
	}

	// 新增商品
	@PostMapping("/mall/addProduct")
	@ResponseBody
	public Product addProduct(@ModelAttribute("product") Product p,
			@RequestParam(required = false) MultipartFile pImg) {
		if (pImg != null) {
			try {
				BufferedInputStream bis = new BufferedInputStream(pImg.getInputStream());
				p.setProductImg(bis.readAllBytes());
				bis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return pService.addProduct(p);
	}

	// 透過ID刪除商品
	@DeleteMapping("/mall/deleteProductById")
	@ResponseBody
	public String deleteProductById(@RequestParam Integer id) {
		if (pService.findProductById(id) != null) {
			pService.deleteProductById(id);
			return "刪除成功";
		}
		return "刪除失敗";
	}

	// 透過ID更改商品
	@PutMapping("/mall/updateProductById")
	@ResponseBody
	public String updateProductById(@ModelAttribute Product p, @RequestParam(required = false) MultipartFile pImg) {
		if (pService.findProductById(p.getProductId()) != null) {
			pService.updateProductById(p);
			return "修改成功";
		}
		return "修改失敗";
	}
}
