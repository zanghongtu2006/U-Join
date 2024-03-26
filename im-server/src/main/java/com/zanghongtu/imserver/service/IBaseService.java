package com.zanghongtu.imserver.service;

import org.antlr.v4.runtime.misc.NotNull;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

import java.util.List;
import java.util.Optional;

public interface IBaseService<T, ID> {

    List<T> findAll();

    List<T> findAll(Sort sort);

    Page<T> findAll(Pageable pageable);

    List<T> findAllById(Iterable<ID> ids);

    long count();

    void deleteById(ID id);

    void delete(T entity);

//    void deleteAllById(Iterable<? extends ID> ids);

    void deleteAll(Iterable<? extends T> entities);

    void deleteAll();

//    <S extends T> S save(S entity);

    <S extends T> S insert(S entity);

    <S extends T> S update(S entity);

    <S extends T> List<S> saveAll(Iterable<S> entities);

    Optional<T> findById(ID id);

    boolean existsById(ID id);

    void flush();

    <S extends T> S saveAndFlush(S entity);

//    <S extends T> List<S> saveAllAndFlush(Iterable<S> entities);

    void deleteAllInBatch(Iterable<T> entities);

//    void deleteAllByIdInBatch(Iterable<ID> ids);

    void deleteAllInBatch();

    T getOne(ID id);

    T getById(ID id);

    T getReferenceById(ID id);

    <S extends T> Optional<S> findOne(Example<S> example);

    <S extends T> List<S> findAll(Example<S> example);

    <S extends T> List<S> findAll(Example<S> example, Sort sort);

    <S extends T> Page<S> findAll(Example<S> example, Pageable pageable);

    <S extends T> long count(Example<S> example);

    <S extends T> boolean exists(Example<S> example);

    <S extends T> Page<S> search(@NotNull Example<S> example, Integer pageIndex, Integer pageSize);

    <S extends T> Page<S> search(@NotNull Example<S> example, @NotNull Sort sort, Integer pageIndex, Integer pageSize);

    Page<T> search(@NotNull Specification<T> spec, Integer pageIndex, Integer pageSize);

    Page<T>  search(@NotNull Specification<T> spec, @NotNull Sort sort, Integer pageIndex, Integer pageSize);

    Page<T> findAll(Specification<T> spec, Integer page, Integer pageSize);

    Page<T> findAll(Specification<T> spec, Sort sort, Integer page, Integer pageSize);

    public List<T> findAll(Specification<T> spec);
}
