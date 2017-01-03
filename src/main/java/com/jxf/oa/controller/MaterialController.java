package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.UserService;
import com.jxf.oa.util.LangUtil;

@Controller
@RequestMapping("/material")
public class MaterialController extends BaseController {
	@Autowired
	protected MaterialService materialService;

	@Autowired
	protected UserService userService;

	@RequestMapping("/materiallist")
	public String list(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		Page<Material> materiallists = materialService.findAllMaterial(page, getPageSize(), user.getId());
		model.addAttribute("page", materiallists);
		return "erp/materiallist";
	}

	@RequestMapping("/allmateriallist")
	public String allMaterialList(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		Page<Material> materiallists = materialService.findAllMaterial(page, getPageSize(), user.getId());
		model.addAttribute("page", materiallists);

		return "erp/allmateriallist";
	}

	@RequestMapping("/creatematerial")
	public String createMaterial(Model model, @Valid @ModelAttribute Material material, Errors errors) {
		return "erp/creatematerial";
	}

	@RequestMapping("/savecreatematerial")
	public String savecreateMaterial(Model model, @Valid @ModelAttribute("material") Material material, Errors errors) {
		if (StringUtils.isBlank(material.getMaterialId())) {
			String materialId = LangUtil.getMessage("label.materialid", ctx);
			errors.reject("validation.required", new String[] { materialId }, "Material Id is requried");
		}

		if (errors.hasErrors()) {
			return "erp/creatematerial";
		}

		// Material ml = new Material();
		// Material parent = new Material();
		// ml.setMaterialId(material.getMaterialId());
		material.setMaterialId(material.getMaterialId().toUpperCase());
		List mlist = materialService.findAllByExample(material);
		String hql = "from Material where materialId='"+material.getMaterialId()+"'"
					+" and weight = "+material.getWeight()+""
					+" and thickness = "+material.getThickness()+""
					+" and color = '"+material.getColor()+"'"
					+" and length = "+material.getLength()+"";
		mlist = materialService.findByHql(hql);
		if (mlist != null && mlist.size() > 0) {
			errors.reject("validation.materialexist.invalid", "The material already exists");
		}

		if (errors.hasErrors()) {
			return "erp/creatematerial";
		}

		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		material.setCount(0);
		if (material.getCount() != null && material.getRiskcount() != null
				&& material.getCount() < material.getRiskcount()) {
			material.setRiskflag(1);
		}
		material.setCreatedBy(user);
		material.setCreatedOn(new Date());
		material.setUpdatedBy(user);// Annie update
		material.setUpdatedOn(new Date());// Annie update
		materialService.save(material);

		return "materialSuccess";
	}

	@RequestMapping("editmaterial")
	public String editMaterial(Model model, Material material, Errors errors) {
		material = materialService.findById(Material.class, material.getId());
		model.addAttribute("material", material);
		return "erp/editmaterial";
	}

	@RequestMapping("/saveeditmaterial")
	public String saveeditMaterial(Model model, @Valid @ModelAttribute("material") Material material, Errors errors) {
		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		if (material.getCount() != null && material.getRiskcount() != null
				&& material.getCount() < material.getRiskcount()) {
			material.setRiskflag(1);
		}
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		if (material.getCount() != null && material.getRiskcount() != null
				&& material.getCount() < material.getRiskcount()) {
			material.setRiskflag(1);
		}
		material.setUpdatedBy(user);
		material.setUpdatedOn(new Date());
		materialService.update(material);

		return "materialSuccess";
	}

	@RequestMapping("/deletematerial")
	public String deleteMaterial(@RequestParam Integer id) {
		Material material = new Material();
		material.setId(id);
		try {
			materialService.delete(material);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/material/allmateriallist/";
	}

	// for pop up of transaction
	@RequestMapping("searchmaterial")
	public String searchMaterial(Model model, @Valid @ModelAttribute("material") Material material, Errors errors,
			String uiElement) {
		List<Material> materialList = null;
		if (material.getMaterialId() != null && material.getMaterialId() != "") {
			materialList = materialService.findAllByExample(material);
		} else {
			materialList = materialService.findAll(Material.class);
		}
		model.addAttribute("materiallist", materialList);
		model.addAttribute("uiElement", uiElement);
		return "erp/searchmateriallist";
	}

	@RequestMapping("findriskmaterialsize")
	@ResponseBody
	public String getRiskMaterialCount() {
		Material ml = new Material();
		ml.setRiskflag(1);
		List mlist = materialService.findAllByExample(ml);
		return String.valueOf(mlist.size());
	}

	@RequestMapping("searchriskmaterial")
	public String searchRiskMaterial(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		Material material = new Material();
		material.setRiskflag(1);
		List<Material> materialList = materialService.findAllByExample(material);
		model.addAttribute("material", material);
		model.addAttribute("materiallist", materialList);
		return "erp/riskmateriallist";
	}

	@RequestMapping("editriskmaterial")
	public String editRiskMaterial(Model model, Material material, Errors errors) {
		material = materialService.findById(Material.class, material.getId());
		model.addAttribute("material", material);
		return "erp/editriskmaterial";
	}

	@RequestMapping("searchmaterialtry")
	public String searchMaterialtry(Model model, @Valid @ModelAttribute("material") Material material,
			@RequestParam(defaultValue = "N") String editflag, Errors errors, String uiElement) {
		List<Material> materialList = materialService.findAllByExample(material);
		model.addAttribute("materiallist", materialList);
		model.addAttribute("uiElement", uiElement);
		return "erp/searchmateriallist1";
	}
	
	@RequestMapping("fillmaterialorders")
	@ResponseBody
	public String fillMaterialOrders(Model model, String materialId, Double thickness, String color, Double length,
			@RequestParam(defaultValue = "N") String editflag, Errors errors, String uiElement) {
		Material material = new Material();
		if(materialId!=null && materialId !="")
			material.setMaterialId(materialId);
		if(thickness!=null)
			material.setThickness(thickness);
		if(color!=null && color !="")
			material.setColor(color);
		if(length!=null)
			material.setLength(length);
		List<Material> materialList = materialService.findAllByExample(material);
		model.addAttribute("materiallist", materialList);
		model.addAttribute("uiElement", uiElement);
		return "erp/searchmateriallist1";
	}
	
	@RequestMapping("fillmaterialfororder")
	public String fillMaterialforOrder(Model model, @Valid @ModelAttribute("material") Material material,
			@RequestParam(defaultValue = "N") String editflag, Errors errors, String uiElement) {
		List<Material> materialList = materialService.findAll(Material.class);
		model.addAttribute("materiallist", materialList);
		model.addAttribute("uiElement", uiElement);
		return "erp/fillmaterialfororder";
	}
	
}
