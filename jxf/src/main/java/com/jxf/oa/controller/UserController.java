package com.jxf.oa.controller;

import com.jxf.oa.bean.Context;
import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Option;
import com.jxf.oa.entity.Order;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.OrderService;
import com.jxf.oa.services.UserService;
import com.jxf.oa.util.BeanCopier;
import com.jxf.oa.util.JCryption;
import com.jxf.oa.util.LangUtil;
import com.jxf.oa.util.MD5Helper;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import java.security.KeyPair;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Description Here
 *
 * @author Michael
 */
@Controller
@RequestMapping("/user")
public class UserController extends BaseAdminController {

    private Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    UserService userService;
    
    @Autowired
    protected OrderService orderService;
    
    @Autowired  
    private HttpSession session;  

    @ModelAttribute
    public User getUser() {
        return new User();
    }

    @RequestMapping({"/", "/list"})
    public String listUsers(Model model) {

        List<User> users = userService.findAll(User.class);

        model.addAttribute("users", users);

        return "admin/user/list";
    }
    
    @RequestMapping("/jxfusers")
    public String listjxfUsers(Model model, @ModelAttribute User user,Errors errors) {
    	
        List<User> users = userService.findAll(User.class);
        model.addAttribute("users", users);

        return "erp/alljxfusers";
    }
    
    @RequestMapping("/managejxfuser")
    public String managejxfUsers(Model model, User user) {
    	user = userService.findById(User.class, user.getId());
    	UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      	User currentuser = (User)userDetails;
      	model.addAttribute("user", user);
        return "erp/managejxfuser";
    }
    @RequestMapping("/savemanagejxfuser")
    public String savemanagejxfUsers(Model model, User user, Errors errors) {

    	UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      	User currentuser = (User)userDetails;
      	
      	if(currentuser.getIsadmin()==null || !currentuser.getIsadmin()){
      		errors.reject("validation.user.notadmin");
      		return "erp/managejxfuser";
      	}
      	Boolean isadmin = user.getIsadmin();
      	user = userService.findById(User.class, user.getId());
      	user.setIsadmin(isadmin);
      	user.setUpdatedBy(currentuser);
      	user.setUpdatedOn(new Date());
      	userService.update(user);
      	return "redirect:/user/jxfusers/";
    }
    
    @RequestMapping("/deletejxfuser")
    public String deletejxfUsers(Model model, User user, Errors errors) {
    	UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
      	User currentuser = (User)userDetails;
      	
      	if(currentuser.getIsadmin()==null || !currentuser.getIsadmin()){
      		errors.reject("validation.user.notadmin");
      		List<User> users = userService.findAll(User.class);
            model.addAttribute("users", users);
            return "erp/alljxfusers";
      	}
      	if(currentuser.getId().equals(user.getId())){
      		errors.reject("validation.user.deleteself");
      		List<User> users = userService.findAll(User.class);
            model.addAttribute("users", users);
            return "erp/alljxfusers";
      	}
    	user = userService.findById(User.class, user.getId());
    	try{
    		userService.delete(user);
    	}
    	catch(Exception e){
    		errors.reject("validation.user.notadmin");
      		return "redirect:/user/jxfusers/";
    	}
    	return "redirect:/user/jxfusers/";
    }
    
    @RequestMapping("/add")
    public String addUser(Model model, User user,@RequestParam(required = false, defaultValue = "C") String mode) {    	
    	 UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
       	 User currentuser = (User)userDetails;
    	user = new User();
    	String returnstr="erp/userdetailclient";
    	
    	user.setPassword("");
        model.addAttribute("user", user);
        List supportLang = LangUtil.getSupportLanguage(ctx);
        List clientType = getClientType();
        List userType =LangUtil.getUserTypes(ctx);
        List freelanceslist=getFreelanceType();
        List qualitylist = getFreelanceQuality();
        List industrylist = getIndustry();
        List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);

		model.addAttribute("srclanlist",srclanlist);
		model.addAttribute("tarlanlist",tarlanlist);
        model.addAttribute("supportLangs", supportLang);
        model.addAttribute("clientTypes", clientType);    
        model.addAttribute("freelanceslist", freelanceslist);
        model.addAttribute("qualitylist", qualitylist);
        model.addAttribute("industrylist", industrylist);
        model.addAttribute("userTypes", userType);
        model.addAttribute("currentuser", currentuser);
        setOptions(model, user);
        return returnstr;
    }

    @RequestMapping("/edit")
    public String editUser(Model model, User user,@RequestParam(required = false, defaultValue = "N") String mode) {
    	if("Y".equalsIgnoreCase(mode)){
    		 UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	       	 user = (User)userDetails;
    	}else {
	        if(user.getId() != null) {
	            user = userService.findById(User.class, user.getId());  	            
    	    }
    	}
    	
    	
    	
    	user.setPassword("");
        model.addAttribute("user", user);
        List supportLang = LangUtil.getSupportLanguage(ctx);
        List clientType = getClientType();
        List userType =LangUtil.getUserTypes(ctx);
        List freelanceslist=getFreelanceType();
        List qualitylist = getFreelanceQuality();
        List industrylist = getIndustry();
        List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);
		List currlist = getCurrency();

		model.addAttribute("srclanlist",srclanlist);
		model.addAttribute("tarlanlist",tarlanlist);
        model.addAttribute("supportLangs", supportLang);
        model.addAttribute("clientTypes", clientType);
        model.addAttribute("freelanceslist", freelanceslist);
        model.addAttribute("qualitylist", qualitylist);
        model.addAttribute("industrylist", industrylist);
        model.addAttribute("userTypes", userType);
        model.addAttribute("currentuser", user);
        model.addAttribute("currlist",currlist);
       
        setOptions(model, user);
        return "";
    }

    @RequestMapping("/save")
    public String saveUser(Model model, @Valid @ModelAttribute User user, Errors errors) {
    	if(StringUtils.isBlank(user.getUsername())){
	    	String name = LangUtil.getMessage("label.user.name", ctx);
			errors.reject("validation.required", new String[]{name}, "Name is requried");
		}
    	
    	List supportLang = LangUtil.getSupportLanguage(ctx);
        List clientType = getClientType();
        List userType =LangUtil.getUserTypes(ctx);
        List freelanceslist=getFreelanceType();
        List qualitylist = getFreelanceQuality();
        List industrylist = getIndustry();
        List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);
		List currlist = getCurrency();

		Locale locale=LangUtil.getLocale("zh_CN");
        
        session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME , locale);
	 

        return "/erp/erphome";
    }

    @RequestMapping("/delete")
    public String deleteUser(@RequestParam Integer id) {
        User user = new User();
        user.setId(id);
        try {
            userService.delete(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/admin/user/";
    }


    private void setOptions(Model model, User user) {
        // put Options into model
        Option example = new Option();
        example.setType(Context.OPTS_USER);
        List<Option> options = userService.findAllByExample(example);
        Map<String, String[]> optionsMap = new HashMap<String, String[]>();
        for (Option option : options) {
            optionsMap.put(option.getName(), option.getOptionsAsArray());
        }
        model.addAttribute("options", optionsMap);
    }

//    @RequestMapping("/editUser")
//    public String editUserInfo(Model model, User user) {
//    	 UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
//    	 user = (User)userDetails;
//    	 
//    	 //add this to refresh after change the language
//    	 user = userService.findById(User.class, user.getId());
//    	 
//    	 
//    	 List supportLang = LangUtil.getSupportLanguage(ctx);
//         List clientType = getClientType();
//         List srclanlist = LangUtil.getSrcTargetLang(ctx);
// 		 List tarlanlist = LangUtil.getSrcTargetLang(ctx);
//
// 		 model.addAttribute("srclanlist",srclanlist);
// 		 model.addAttribute("tarlanlist",tarlanlist);
//         model.addAttribute("supportLangs", supportLang);
//         model.addAttribute("clientTypes", clientType);
//         model.addAttribute("user", user);
//        return "erp/userinfo";
//    }
//
//    @RequestMapping("/saveUser")
//    public String saveEditUser(Model model,@Valid @ModelAttribute User user, Errors errors) {
//       
//        if(errors.hasErrors()) {
//        	return "erp/userinfo";
//        }
//        
//        if (user.getId() != null) {
//	        User u = userService.findById(User.class, user.getId());
//	        
//	        
//	        BeanCopier.buildCopier(u, user)
//	        .excludeDefault()
//	        //.exclude("assetsType", "serialNumber")
//	        .copy();
//	        
//	        if(!"".equals(user.getPassword())){
//	            u.setPassword(user.getPassword());
//	         }
//	        u.setLanguage(user.getLanguage());
//	        userService.update(u);
//        }else{
//        	userService.save(user);
//        }
//	 
//        Locale locale=LangUtil.getLocale(user.getLanguage());
//      
//        session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME , locale);
//	        
//
//        return "redirect:/user/editUser";
//    }
    
    @RequestMapping("/clientlist")
    public String findClientUser(Model model,@RequestParam(required = false, defaultValue = "1") Integer page, @ModelAttribute User user,Errors errors) {
       
    	 Page<User> userlists = userService.findUser(page, getPageSize(),LangUtil.CLIENT);
         model.addAttribute("page", userlists);

        return "erp/userclientlist";
    }
    
    @RequestMapping("/freelancerList")
    public String findFreeLanceUser(Model model,@RequestParam(required = false, defaultValue = "1") Integer page, @ModelAttribute User user,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
        
        Page<User> userlists = userService.findUser(page, getPageSize(),LangUtil.FREELANCER);
        model.addAttribute("page", userlists);
 
        return "erp/userfreelancerlist";
    }
    
    @RequestMapping("/searchclient")
    public String searchclient(Model model,@ModelAttribute User user,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
    
        
        List<User> userlists = userService.findUser(user);
        model.addAttribute("clientlist", userlists);
        
        return "erp/searchuserlist"; 
    }
    
    @RequestMapping("/searchfreelancer")
    public String searchFreelancer(Model model,@ModelAttribute User user,@RequestParam(required = false, defaultValue = "") String fid,
    		@RequestParam(defaultValue = "") String po, @RequestParam(defaultValue = "N") String freeid,
    		@RequestParam(defaultValue = "") String editflag,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
     
        
        Map<String, Object> args = new HashMap<String, Object>();
        List assignees = new ArrayList();
        if(StringUtils.isNotBlank(fid)){
        	assignees.add(Integer.valueOf(freeid));
        }else{
	        Order order = new Order();
	        order.setPo(po);
	        List orders = orderService.findAllByExample(order);
	       
	        Iterator itr = orders.iterator();
	        while(itr.hasNext()){
	        	Order ord = (Order)itr.next();
	        	if(ord.getAssignee()!=null){
	        	  assignees.add(ord.getAssignee().getId());
	        	}
	        }
        }
        
        if(assignees.size()>0){
            args.put("id", assignees); 
        }
        List<User> userlists = userService.findUser(user,args);
        List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);
		List industrylist = getIndustry();
		Map langs = LangUtil.getSrcTargetLang();
	    model.addAttribute("langmap", langs);

		model.addAttribute("srclanlist",srclanlist);
		model.addAttribute("tarlanlist",tarlanlist);
        model.addAttribute("clientlist", userlists);
        model.addAttribute("industrylist", industrylist);
        model.addAttribute("editflag", editflag);
        String target ="erp/searchfreelancerlist";
        
        if(StringUtils.isNotBlank(fid)){
        	target ="erp/searchfreelancerlist1";
        	model.addAttribute("fid", fid);
        }
        
        return target; 
    }
    
    @RequestMapping("/searchclientuser")
    public String searchUserClient(Model model,@ModelAttribute User user,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
        if(user==null){
        	user=  new User();
        }

        model.addAttribute("user", user);
        
        return "erp/searchuserlist"; 
    }
    
    @RequestMapping("/searchfreelanceruser")
    public String searchUser(Model model,@ModelAttribute User user,@RequestParam(required = false, defaultValue = "") String fid,
    		@RequestParam(defaultValue = "") String po,@RequestParam(defaultValue = "") String freeid,
    		@RequestParam(defaultValue = "N") String editflag, Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
        if(user==null){
        	user=  new User();
        }

        model.addAttribute("user", user);
        List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);
		List industrylist = getIndustry();

		model.addAttribute("srclanlist",srclanlist);
		model.addAttribute("tarlanlist",tarlanlist);
		model.addAttribute("industrylist", industrylist);
		
        String target ="erp/searchfreelancerlist";
        
        if(StringUtils.isNotBlank(fid)){
        	target ="erp/searchfreelancerlist1";
        	model.addAttribute("fid", fid);
        	model.addAttribute("freeid", freeid);
        }
        
        model.addAttribute("po", po);
        model.addAttribute("editflag", editflag);
        return target; 
      
    }
    
    @RequestMapping("/userclientinfo")
    public String userClientInfo(Model model,@ModelAttribute User user,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
        if(user==null){
        	user=  new User();
        }      
        
        Order order =new Order();       
        user = userService.findByExample(user);
        order.setClient(user);
        String hql ="select order from Order order where order.client.id ="+user.getId();
        List<Order> orderlists = orderService.findByHql(hql);
        
        model.addAttribute("user", user);
        model.addAttribute("orderlists", orderlists);
        Map langs = LangUtil.getSrcTargetLang();
        Map statusList = LangUtil.getStatusMap(ctx);
        model.addAttribute("statusmap", statusList);
        model.addAttribute("langmap", langs);
        return "erp/userclientinfo"; 
    }
    
    @RequestMapping("/userfreelancerinfo")
    public String userFreelancerInfo(Model model,@ModelAttribute User user,Errors errors) {
       
        if(errors.hasErrors()) {
            //return editUser(model, user);
        }
        if(user==null){
        	user=  new User();
        }

        Order order =new Order();       
        user = userService.findByExample(user);
        order.setClient(user);
        String hql ="select order from Order order where order.assignee.id ="+user.getId();
        List<Order> orderlists = orderService.findByHql(hql);
        
        model.addAttribute("user", user);
        model.addAttribute("orderlists", orderlists);
        
        return "erp/userfreelancerinfo"; 
    }
}
