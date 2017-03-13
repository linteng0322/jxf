package com.jxf.oa.controller;

import java.util.Date;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jxf.oa.entity.SysConf;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.SysConfService;
import com.jxf.oa.services.UserService;

@Controller
@RequestMapping("/sysconf")
public class SysConfController extends BaseController {
	@Autowired
	protected SysConfService sysconfService;

	@Autowired
	protected UserService userService;

	@RequestMapping("setappconf")
	public String setappconf(Model model, SysConf sysconf, Errors errors) {
		return "erp/appconf";
	}
	
	@RequestMapping("setsysconf")
	public String editSysconf(Model model, SysConf sysconf, Errors errors) {
		List<SysConf> sysconfl = sysconfService.findAll(SysConf.class);
		if(sysconfl.size()==0){
			sysconf = new SysConf();
		}else{
			sysconf = sysconfl.get(0);
		}
		model.addAttribute("sysconf", sysconf);
		return "erp/setsysconf";
	}
	
	@RequestMapping("savesysconf")
	public String saveSysconf(Model model, @Valid @ModelAttribute("sysconf") SysConf sysconf, Errors errors) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      	User user = (User)userDetails;
      	
      	if(user.getIsadmin()==null || !user.getIsadmin()){
      		errors.reject("validation.user.notadmin");
      		model.addAttribute("sysconf", sysconf);
    		return "erp/setsysconf";
      	}
      	sysconf.setUpdatedBy(user);
      	sysconf.setUpdatedOn(new Date());
      	if(sysconf.getId()==null){
      		sysconf.setCreatedBy(user);
      		sysconf.setCreatedOn(new Date());
      		sysconfService.save(sysconf);
      	}else{
      		sysconfService.update(sysconf);
      	}
		model.addAttribute("sysconf", sysconf);
		return "sysconfSuccess";
	}
	
	@RequestMapping(value = "getcompanyname", produces = "text/html;charset=UTF-8;")
	@ResponseBody
	public String getcompanyname(){
		String companyname = "";
		SysConf sysconf;
		List<SysConf> sysconfl = sysconfService.findAll(SysConf.class);
		if(sysconfl.size()!=0){
			sysconf = sysconfl.get(0);
			companyname=sysconf.getCompanyname();
		}
		return companyname;
	}
}
