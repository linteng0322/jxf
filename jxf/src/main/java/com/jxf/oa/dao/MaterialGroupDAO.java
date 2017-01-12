package com.jxf.oa.dao;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MaterialGroup;

public interface MaterialGroupDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<MaterialGroup> findMaterialGroup(int pageIndex, int pageSize, int userId);
    
}
