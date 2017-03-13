package com.jxf.oa.dao;

import org.hibernate.Criteria;
import org.hibernate.criterion.DetachedCriteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Material;
import com.jxf.oa.entity.User;

public interface MaterialDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<Material> findMaterial(Material material, int pageIndex, int pageSize, int userId);
    
}
