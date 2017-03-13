package com.jxf.oa.services;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.User;

/**
 * Description Here
 *
 * @author Michael
 */
public interface MaterialService extends BaseService, UserDetailsService {

	Page<Material> findAllMaterial(Material material, int pageIndex, int pageSize, int userId);
	
	
}
