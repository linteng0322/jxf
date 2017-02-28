package com.jxf.oa.dao;

import java.util.List;

import org.hibernate.Criteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.MemoJXFOrder;

public interface MemoJXFOrderDAO extends BaseDAO {
    
	public int findTotalSize(Criteria criteria);

    public Page<MemoJXFOrder> findJxfOrder(int pageIndex, int pageSize, int userId);

	public List<MemoJXFOrder> findJxfOrderListByExample(MemoJXFOrder order, int userId);
    
}
