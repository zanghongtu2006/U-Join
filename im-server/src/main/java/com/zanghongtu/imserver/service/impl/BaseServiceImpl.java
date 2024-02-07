package com.zanghongtu.imserver.service.impl;


import com.zanghongtu.imserver.service.IBaseService;
import com.zanghongtu.imserver.threadlocal.ReqInfoOperator;
import org.antlr.v4.runtime.misc.NotNull;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public class BaseServiceImpl<T, ID> implements IBaseService<T, ID> {
    private final JpaRepositoryImplementation<T, ID> repository;

    public BaseServiceImpl(JpaRepositoryImplementation<T, ID> repository) {
        this.repository = repository;
    }

    @NotNull
    @Override
    public List<T> findAll() {
        return repository.findAll();
    }

    @NotNull
    @Override
    public List<T> findAll(@NotNull Sort sort) {
        return repository.findAll(sort);
    }

    @NotNull
    @Override
    public Page<T> findAll(@NotNull Pageable pageable) {
        return repository.findAll(pageable);
    }

    @NotNull
    @Override
    public List<T> findAllById(@NotNull Iterable<ID> ids) {
        return repository.findAllById(ids);
    }

    @Override
    public long count() {
        return repository.count();
    }

    @Override
    public void deleteById(@NotNull ID id) {
        repository.deleteById(id);
    }

    @Override
    public void delete(@NotNull T entity) {
        repository.delete(entity);
    }

//    @Override
//    public void deleteAllById(@NotNull Iterable<? extends ID> ids) {
//        repository.deleteAllById(ids);
//    }

    @Override
    public void deleteAll(@NotNull Iterable<? extends T> entities) {
        repository.deleteAll(entities);
    }

    @Override
    public void deleteAll() {
        repository.deleteAll();
    }

    @NotNull
    @Override
    public <S extends T> S save(@NotNull S entity) {
        return repository.save(entity);
    }

    @Override
    public <S extends T> S insert(S entity) {
        try {
            Method setCreateTime = entity.getClass().getMethod("setCreateTime", Date.class);
            Method setUpdateTime = entity.getClass().getMethod("setUpdateTime", Date.class);
            Method setCreator = entity.getClass().getMethod("setCreatedBy", String.class);
            Method setUpdator = entity.getClass().getMethod("setUpdatedBy", String.class);
            Date date = new Date();
            String uid = null;
            if (ReqInfoOperator.get().getUserId().isPresent()) {
                uid = ReqInfoOperator.get().getUserId().get();
            }
            setCreateTime.invoke(entity, date);
            setUpdateTime.invoke(entity, date);
            setCreator.invoke(entity, uid);
            setUpdator.invoke(entity, uid);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
        return repository.save(entity);
    }

    @Override
    public <S extends T> S update(S entity) {
        try {
            Method setUpdateTime = entity.getClass().getMethod("setUpdateTime", Date.class);
            Method setUpdator = entity.getClass().getMethod("setUpdatedBy", String.class);
            Date date = new Date();
            String uid = null;
            if (ReqInfoOperator.get().getUserId().isPresent()) {
                uid = ReqInfoOperator.get().getUserId().get();
            }
            setUpdateTime.invoke(entity, date);
            setUpdator.invoke(entity, uid);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
        return repository.save(entity);
    }

    @NotNull
    @Override
    public <S extends T> List<S> saveAll(@NotNull Iterable<S> entities) {
        return repository.saveAll(entities);
    }

    @NotNull
    @Override
    public Optional<T> findById(@NotNull ID id) {
        return repository.findById(id);
    }

    @Override
    public boolean existsById(@NotNull ID id) {
        return repository.existsById(id);
    }

    @Override
    public void flush() {
        repository.flush();
    }

    @NotNull
    @Override
    public <S extends T> S saveAndFlush(@NotNull S entity) {
        return repository.saveAndFlush(entity);
    }

//    @NotNull
//    @Override
//    public <S extends T> List<S> saveAllAndFlush(@NotNull Iterable<S> entities) {
//        return repository.saveAllAndFlush(entities);
//    }

    @Override
    public void deleteAllInBatch(@NotNull Iterable<T> entities) {
        repository.deleteInBatch(entities);
    }

//    @Override
//    public void deleteAllByIdInBatch(@NotNull Iterable<ID> ids) {
//        repository.deleteAllByIdInBatch(ids);
//    }

    @Override
    public void deleteAllInBatch() {
        repository.deleteAllInBatch();
    }

    @Override
    public T getOne(@NotNull ID id) {
        return repository.getOne(id);
    }

    @NotNull
    @Override
    public T getById(@NotNull ID id) {
        return repository.getReferenceById(id);
    }

    @Override
    public T getReferenceById(ID id) {
        return repository.getReferenceById(id);
    }

    @NotNull
    @Override
    public <S extends T> Optional<S> findOne(@NotNull Example<S> example) {
        return repository.findOne(example);
    }

    @NotNull
    @Override
    public <S extends T> List<S> findAll(@NotNull Example<S> example) {
        return repository.findAll(example);
    }

    @NotNull
    @Override
    public <S extends T> List<S> findAll(@NotNull Example<S> example, @NotNull Sort sort) {
        return repository.findAll(example, sort);
    }

    @NotNull
    @Override
    public <S extends T> Page<S> findAll(@NotNull Example<S> example, @NotNull Pageable pageable) {
        return repository.findAll(example, pageable);
    }

    @Override
    public <S extends T> long count(@NotNull Example<S> example) {
        return repository.count(example);
    }

    @Override
    public <S extends T> boolean exists(@NotNull Example<S> example) {
        return repository.exists(example);
    }

    @Override
    public <S extends T> Page<S> search(@NotNull Example<S> example, Integer pageIndex, Integer pageSize) {
        PageRequest pageRequest = PageRequest.of(pageIndex, pageSize);
        return repository.findAll(example, pageRequest);
    }

    @Override
    public <S extends T> Page<S> search(@NotNull Example<S> example, @NotNull Sort sort, Integer pageIndex, Integer pageSize) {
        PageRequest pageRequest = PageRequest.of(pageIndex, pageSize, sort);
        return repository.findAll(example, pageRequest);
    }

    @Override
    public Page<T> search(@NotNull Specification<T> spec, Integer pageIndex, Integer pageSize) {
        PageRequest pageRequest = PageRequest.of(pageIndex, pageSize);
        return repository.findAll(spec, pageRequest);
    }

    @Override
    public Page<T> search(@NotNull Specification<T> spec, @NotNull Sort sort, Integer pageIndex, Integer pageSize) {
        PageRequest pageRequest = PageRequest.of(pageIndex, pageSize, sort);
        return repository.findAll(spec, pageRequest);
    }

    @Override
    public Page<T> findAll(Specification<T> spec, Integer page, Integer pageSize) {
        Pageable pageRequest = PageRequest.of(page, pageSize);
        return repository.findAll(spec, pageRequest);
    }

    @Override
    public Page<T> findAll(Specification<T> spec, Sort sort, Integer page, Integer pageSize) {
        Pageable pageRequest = PageRequest.of(page, pageSize, sort);
        return repository.findAll(spec, pageRequest);
    }

    @Override
    public List<T> findAll(Specification<T> spec) {
        return repository.findAll(spec);
    }
}
