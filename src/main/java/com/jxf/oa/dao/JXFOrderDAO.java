package com.jxf.oa.dao;

import java.util.List;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.JXFOrder;

public interface JXFOrderDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<JXFOrder> findJxfOrder(int pageIndex, int pageSize, int userId);

	public List<JXFOrder> findJxfOrderListByExample(JXFOrder order, int userId);
    
}
