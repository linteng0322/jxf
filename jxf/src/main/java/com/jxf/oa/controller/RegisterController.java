package com.jxf.oa.controller;

import java.security.KeyPair;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jxf.oa.entity.RegistrantValue;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.RegisterService;
import com.jxf.oa.util.JCryption;
import com.jxf.oa.util.LangUtil;
import com.jxf.oa.util.MD5Helper;
import com.octo.captcha.service.image.ImageCaptchaService;

@Controller
@RequestMapping("/register")
public class RegisterController extends BaseController {

	@Autowired
	private RegisterService registerService;
	
	@Autowired
    private ImageCaptchaService imageCaptchaService;
	
	@Autowired  
	private HttpSession session;
	 
	@RequestMapping("/new")
    public String register(Model model, @ModelAttribute RegistrantValue registrant) {
		registrant = new RegistrantValue ();
		List srclanlist = LangUtil.getSrcTargetLang(ctx);
		List tarlanlist = LangUtil.getSrcTargetLang(ctx);

		model.addAttribute("srclanlist",srclanlist);
		model.addAttribute("tarlanlist",tarlanlist);
        model.addAttribute("registrant", registrant);
        return "register";
    }
	
	@RequestMapping("/registerSub")
    public String registerSub(Model model, @Valid @ModelAttribute("registrant") RegistrantValue registrant, BindingResult errors, HttpServletRequest  request) {
		
//		Boolean isResponseCorrect = imageCaptchaService.validateResponseForID(request.getSession().getId(), registrant.getVerifyCode());
//		if(!isResponseCorrect){
//			errors.rejectValue("verifyCode", "validation.verificationcode.invalid", "Invalid verfication Code");
//		}
		
		if(!registrant.getPassword().equals(registrant.getConfirmPassword())){
			errors.reject("validation.inconsistpassword.invalid", "Inconsistent password and confirm password");
		}
		
		
		
		if(errors.hasErrors()){
			List srclanlist = LangUtil.getSrcTargetLang(ctx);
			List tarlanlist = LangUtil.getSrcTargetLang(ctx);

			model.addAttribute("srclanlist",srclanlist);
			model.addAttribute("tarlanlist",tarlanlist);
			return "register";
		}
		
		User user =  new User();
		user.setUsername(registrant.getUsername());
		
		
		List users = registerService.findAllByExample(user);
		
		if(users!=null && users.size()>0){
			errors.reject("validation.userexist.invalid", "The username already exists");
			return "register";
		}
	
		KeyPair keypairs = (KeyPair)session.getAttribute("keys");
		JCryption jcryption = new JCryption();
		String password = registrant.getPassword();
        if(StringUtils.isNotEmpty(password)){
        	password = jcryption.decrypt(password, keypairs);
        	password = new MD5Helper().getMD5ofStr(password);
         }
        
		user.setPassword(password);
		SimpleDateFormat dateformat=new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String userno=dateformat.format(new Date());
		
		
		registerService.saveOrUpdate(user);
        return "registerSuccess";
    }

	@RequestMapping("/terms")
    public String term(Model model, @ModelAttribute RegistrantValue registrant) {
		
        return "terms";
    }
	
	@RequestMapping("/privicy")
    public String privicy(Model model, @ModelAttribute RegistrantValue registrant) {
		
        return "privicy";
    }

}
