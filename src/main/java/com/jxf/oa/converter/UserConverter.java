package com.jxf.oa.converter;

import org.springframework.core.convert.converter.Converter;

import com.jxf.oa.entity.User;

/**
 * Description Here
 *
 * @author Michael
 */
public class UserConverter implements Converter<String, User> {
    @Override
    public User convert(String source) {
        return new User(Integer.valueOf(source));
    }
}
