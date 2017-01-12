package com.jxf.oa.services;

import org.springframework.security.core.userdetails.UserDetailsService;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MaterialGroup;

/**
 * Description Here
 *
 * @author Michael
 */
public interface MaterialGroupService extends BaseService, UserDetailsService {

	Page<MaterialGroup> findAllMaterialGroup(int pageIndex, int pageSize, int userId);
	
	
}
