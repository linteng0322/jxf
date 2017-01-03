package com.jxf.oa.services.impl;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jxf.oa.bean.Page;
import com.jxf.oa.dao.MaterialGroupDAO;
import com.jxf.oa.entity.MaterialGroup;
import com.jxf.oa.services.MaterialGroupService;

/**
 * Description Here
 *
 * @author Michael
 */
@Service("materialgroupService")
public class MaterialGroupServiceImpl extends BaseServiceImpl implements MaterialGroupService {
	 @Autowired  
	 private HttpSession session;  
	 
	 @Autowired  
	 private MaterialGroupDAO materialgroupDAO;

	@Override
	public UserDetails loadUserByUsername(String arg0) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<MaterialGroup> findAllMaterialGroup(int pageIndex, int pageSize,int userId) {
		// TODO Auto-generated method stub
		return materialgroupDAO.findMaterialGroup(pageIndex, pageSize, userId);
	}
	 
}
