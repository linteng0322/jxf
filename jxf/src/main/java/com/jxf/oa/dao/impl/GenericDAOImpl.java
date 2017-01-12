package com.jxf.oa.dao.impl;

import com.jxf.oa.dao.GenericDAO;
import com.jxf.oa.entity.IdEntity;

import org.springframework.stereotype.Component;

/**
 * Description Here
 *
 * @author Michael
 */

@Component
public class GenericDAOImpl<T extends IdEntity> extends BaseDAOImpl implements GenericDAO<T> {
}
