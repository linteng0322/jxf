package com.jxf.oa.services.impl;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MaterialDAO;
import com.jxf.oa.dao.UserDAO;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.User;
import com.jxf.oa.services.MaterialService;
import com.jxf.oa.services.UserService;
import com.jxf.oa.util.LangUtil;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.hibernate.sql.JoinType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("materialService")
public class MaterialServiceImpl extends BaseServiceImpl implements MaterialService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private MaterialDAO materialDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Material> findAllMaterial(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return materialDAO.findMaterial(pageIndex, pageSize, userId);
	}
	 
}
