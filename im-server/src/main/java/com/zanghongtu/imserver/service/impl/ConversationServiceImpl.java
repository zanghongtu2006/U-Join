package com.zanghongtu.imserver.service.impl;

import com.zanghongtu.imserver.model.Conversation;
import com.zanghongtu.imserver.model.DictItem;
import com.zanghongtu.imserver.repository.ConversationRepository;
import com.zanghongtu.imserver.service.IConversationService;
import jakarta.persistence.criteria.Predicate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaRepositoryImplementation;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Slf4j
@Service
public class ConversationServiceImpl extends BaseServiceImpl<Conversation, String> implements IConversationService {
    @Autowired
    private ConversationRepository repository;

    public ConversationServiceImpl(JpaRepositoryImplementation<Conversation, String> repository) {
        super(repository);
    }

    @Override
    public Optional<Conversation> getByConversationId(String conversationId) {
        Conversation example = new Conversation();
        example.setConversationId(conversationId);
        return findOne(Example.of(example));
    }

    @Override
    public List<Conversation> findAllByConversationIds(Set<String> conversationIds) {
        Specification<Conversation> itemSpec = (root, criteriaQuery, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(root.get("conversationId").in(conversationIds));
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
        return findAll(itemSpec);
    }
}
