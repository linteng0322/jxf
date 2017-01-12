package com.jxf.oa.dao;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MaterialOrder;

public interface MaterialOrderDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<MaterialOrder> findMaterialOrder(int pageIndex, int pageSize, int userId);
    
}
