package com.jxf.oa.dao;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.Salesman;

public interface SalesmanDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<Salesman> findSalesman(int pageIndex, int pageSize, int userId);
    
}
