package com.jxf.oa.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
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

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.MaterialGroupService;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.UserService;
import com.jxf.oa.util.LangUtil;

@Controller
@RequestMapping("/materialgroup")
public class MaterialGroupController extends BaseController {
	@Autowired
	protected MaterialGroupService materialgroupService;
	
	@Autowired
	protected MaterialService materialService;

	@Autowired
	protected UserService userService;

	@RequestMapping("/materialgrouplist")
	public String list(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;

		Page<MaterialGroup> materialgrouplists = materialgroupService.findAllMaterialGroup(page, getPageSize(), user.getId());
		model.addAttribute("page", materialgrouplists);
		return "erp/materialgrouplist";
	}

	@RequestMapping("/allmaterialgrouplist")
	public String allMaterialGroupList(Model model, @RequestParam(required = false, defaultValue = "1") Integer page) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		Page<MaterialGroup> materialgrouplists = materialgroupService.findAllMaterialGroup(page, getPageSize(), user.getId());
		model.addAttribute("page", materialgrouplists);

		return "erp/allmaterialgrouplist";
	}

	@RequestMapping("/creatematerialgroup")
	public String createMaterialGroup(Model model, @Valid @ModelAttribute("materialgroup") MaterialGroup materialgroup, Errors errors) {
		List<Material> materialchildrenlist = new ArrayList();
		if(materialgroup.getMaterialchildren()!=null){
			String[] children = materialgroup.getMaterialchildren().split(",");
			List<String> materialchildrenidlist = Arrays.asList(children);
			Iterator i = materialchildrenlist.iterator();
			while(i.hasNext()){
				String idString = (String) i.next();
				Integer id = Integer.getInteger(idString);
				Material ml = materialService.findById(Material.class, id);
				materialchildrenlist.add(ml);
			}
		}
		
		//materialchildrenlist = materialService.findAll(Material.class);
		
		
		model.addAttribute("materialchildrenlist", materialchildrenlist);
		return "erp/creatematerialgroup";
	}

	@RequestMapping("/savecreatematerialgroup")
	public String savecreateMaterialGroup(Model model, @Valid @ModelAttribute("materialgroup") MaterialGroup materialgroup,
			 Errors errors) {
		if (StringUtils.isBlank(materialgroup.getMaterialgroupId())) {
			String materialId = LangUtil.getMessage("label.materialid", ctx);
			errors.reject("validation.required", new String[] { materialId }, "Material Id is requried");
		}

		if (errors.hasErrors()) {
			return "erp/creatematerialgroup";
		}

		materialgroup.setMaterialgroupId(materialgroup.getMaterialgroupId().toUpperCase());
		MaterialGroup mg = new MaterialGroup();
		//Material parent = new Material();
		mg.setMaterialgroupId(materialgroup.getMaterialgroupId());

		List mlist = materialgroupService.findAllByExample(mg);
		if (mlist != null && mlist.size() > 0) {
			errors.reject("validation.materialexist.invalid", "The username already exists");

		}

		if (errors.hasErrors()) {
			return "erp/creatematerialgroup";
		}

		
		//materialgroup.setMaterialchildren(materialchildrenstring);
		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		materialgroup.setCreatedBy(user);
		materialgroup.setCreatedOn(new Date());
		materialgroup.setUpdatedBy(user);// Annie update
		materialgroup.setUpdatedOn(new Date());// Annie update
		materialgroupService.save(materialgroup);

		return "materialgroupSuccess";
	}

	@RequestMapping("editmaterialgroup")
	public String editMaterialGroup(Model model, @Valid @ModelAttribute("materialgroup") MaterialGroup materialgroup, Errors errors) {
		materialgroup = materialgroupService.findById(MaterialGroup.class, materialgroup.getId());
		
		List<Material> materialchildrenlist = new ArrayList();
		if(materialgroup.getMaterialchildren()!=null){
			String[] children = materialgroup.getMaterialchildren().split(",");
			List<String> materialchildrenidlist = Arrays.asList(children);
			Iterator i = materialchildrenidlist.iterator();
			while(i.hasNext()){
				String idString = (String) i.next();
				Integer id = Integer.parseInt(idString);
				Material ml = materialService.findById(Material.class, id);
				materialchildrenlist.add(ml);
			}
		}
		
		model.addAttribute("materialchildrenlist", materialchildrenlist);
		model.addAttribute("materialgroup", materialgroup);
		
		return "erp/editmaterialgroup";
	}

	@RequestMapping("/saveeditmaterialgroup")
	public String saveeditMaterialGroup(Model model, @Valid @ModelAttribute("materialgroup") MaterialGroup materialgroup, Errors errors) {
		SimpleDateFormat dateformat1 = new SimpleDateFormat("yyyyMMddHHmmss");
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		User user = (User) userDetails;
		materialgroup.setUpdatedBy(user);
		materialgroup.setUpdatedOn(new Date());
		materialgroupService.update(materialgroup);

		return "materialgroupSuccess";
	}
	
	@RequestMapping("/deletematerialgroup")
    public String deleteMaterialGroup(@RequestParam Integer id) {
        MaterialGroup materialgroup = new MaterialGroup();
        materialgroup.setId(id);
        try {
        	materialgroupService.delete(materialgroup);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/materialgroup/allmaterialgrouplist/";
    }

	// for pop up of transaction
	@RequestMapping("searchmaterialgroup")
	public String searchMaterialGroup(Model model, @Valid @ModelAttribute("materialgroup") MaterialGroup materialgroup, Errors errors) {
		List<MaterialGroup> materialgroupList = materialgroupService.findAllByExample(materialgroup);
		model.addAttribute("materialgrouplist", materialgroupList);
		return "erp/searchmaterialgrouplist";
	}
	
	@RequestMapping("searchmaterialgrouptry")
	public String searchMaterialtry(Model model, 
			@Valid @ModelAttribute("material") MaterialGroup materialgroup, 
			@RequestParam(defaultValue = "N") String editflag, Errors errors, String uiElement) {
		List<MaterialGroup> materialgroupList = materialgroupService.findAllByExample(materialgroup);
		model.addAttribute("materialgrouplist", materialgroupList);
		model.addAttribute("uiElement", uiElement);
		model.addAttribute("materialgroup", materialgroup);
		
		return "erp/searchmaterialgrouplist1";
	}
}
