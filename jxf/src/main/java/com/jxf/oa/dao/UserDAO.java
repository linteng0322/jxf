package com.jxf.oa.dao;

import org.hibernate.Criteria;
import org.hibernate.criterion.DetachedCriteria;

import com.jxf.oa.bean.Page;
import com.jxf.oa.entity.User;

public interface UserDAO extends BaseDAO {

    public int findTotalSize(Criteria criteria);

    public Page<User> findUser(int pageIndex, int pageSize,String userType);
}
