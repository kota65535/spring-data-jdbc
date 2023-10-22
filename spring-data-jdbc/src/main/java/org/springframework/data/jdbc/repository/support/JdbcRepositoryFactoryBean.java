/*
 * Copyright 2017-2023 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.data.jdbc.repository.support;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.aop.TargetSource;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.data.convert.CustomConversions;
import org.springframework.data.jdbc.core.JdbcAggregateOperations;
import org.springframework.data.jdbc.core.JdbcAggregateTemplate;
import org.springframework.data.jdbc.core.convert.BasicJdbcConverter;
import org.springframework.data.jdbc.core.convert.DataAccessStrategy;
import org.springframework.data.jdbc.core.convert.DataAccessStrategyFactory;
import org.springframework.data.jdbc.core.convert.DefaultJdbcTypeFactory;
import org.springframework.data.jdbc.core.convert.InsertStrategyFactory;
import org.springframework.data.jdbc.core.convert.JdbcArrayColumns;
import org.springframework.data.jdbc.core.convert.JdbcConverter;
import org.springframework.data.jdbc.core.convert.JdbcCustomConversions;
import org.springframework.data.jdbc.core.convert.RelationResolver;
import org.springframework.data.jdbc.core.convert.SqlGeneratorSource;
import org.springframework.data.jdbc.core.convert.SqlParametersFactory;
import org.springframework.data.jdbc.core.dialect.JdbcDialect;
import org.springframework.data.jdbc.core.mapping.JdbcSimpleTypes;
import org.springframework.data.jdbc.repository.QueryMappingConfiguration;
import org.springframework.data.jdbc.repository.config.DialectResolver;
import org.springframework.data.mapping.callback.EntityCallbacks;
import org.springframework.data.mapping.model.SimpleTypeHolder;
import org.springframework.data.relational.core.dialect.Dialect;
import org.springframework.data.relational.core.mapping.RelationalMappingContext;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.data.repository.core.support.TransactionalRepositoryFactoryBeanSupport;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations;
import org.springframework.util.Assert;

/**
 * Special adapter for Springs {@link org.springframework.beans.factory.FactoryBean} interface to allow easy setup of
 * repository factories via Spring configuration.
 *
 * @author Jens Schauder
 * @author Greg Turnquist
 * @author Christoph Strobl
 * @author Oliver Gierke
 * @author Mark Paluch
 * @author Hebert Coelho
 * @author Chirag Tailor
 */
public class JdbcRepositoryFactoryBean<T extends Repository<S, ID>, S, ID extends Serializable>
		extends TransactionalRepositoryFactoryBeanSupport<T, S, ID> implements ApplicationEventPublisherAware {

	private ApplicationEventPublisher publisher;
	private BeanFactory beanFactory;
	private RelationalMappingContext mappingContext;
	private JdbcConverter converter;
	private DataAccessStrategy dataAccessStrategy;
	private QueryMappingConfiguration queryMappingConfiguration = QueryMappingConfiguration.EMPTY;
	private NamedParameterJdbcOperations operations;
	private JdbcAggregateOperations jdbcAggregateOperations;
	private EntityCallbacks entityCallbacks;
	private Dialect dialect;
	private JdbcCustomConversions conversions;

	/**
	 * Creates a new {@link JdbcRepositoryFactoryBean} for the given repository interface.
	 *
	 * @param repositoryInterface must not be {@literal null}.
	 */
	public JdbcRepositoryFactoryBean(Class<? extends T> repositoryInterface) {
		super(repositoryInterface);
	}

	@Override
	public void setApplicationEventPublisher(ApplicationEventPublisher publisher) {

		super.setApplicationEventPublisher(publisher);

		this.publisher = publisher;
	}

	/**
	 * Creates the actual {@link RepositoryFactorySupport} instance.
	 */
	@Override
	protected RepositoryFactorySupport doCreateRepositoryFactory() {
		JdbcRepositoryFactory jdbcRepositoryFactory = new JdbcRepositoryFactory(jdbcAggregateOperations, mappingContext,
				dialect, publisher, operations);
		jdbcRepositoryFactory.setQueryMappingConfiguration(queryMappingConfiguration);
		jdbcRepositoryFactory.setEntityCallbacks(entityCallbacks);
		jdbcRepositoryFactory.setBeanFactory(beanFactory);

		return jdbcRepositoryFactory;
	}

	public void setMappingContext(RelationalMappingContext mappingContext) {

		Assert.notNull(mappingContext, "MappingContext must not be null");

		super.setMappingContext(mappingContext);
		this.mappingContext = mappingContext;
	}

	@Autowired(required = false)
	public void setDialect(Dialect dialect) {

		Assert.notNull(dialect, "Dialect must not be null");

		this.dialect = dialect;
	}

	@Autowired(required = false)
	public void setJdbcCustomVersions(JdbcCustomConversions conversions) {
		this.conversions = conversions;
	}

	/**
	 * @param dataAccessStrategy can be {@literal null}.
	 */
	public void setDataAccessStrategy(DataAccessStrategy dataAccessStrategy) {

		Assert.notNull(dataAccessStrategy, "DataAccessStrategy must not be null");

		this.dataAccessStrategy = dataAccessStrategy;
	}

	/**
	 * @param queryMappingConfiguration can be {@literal null}. {@link #afterPropertiesSet()} defaults to
	 *          {@link QueryMappingConfiguration#EMPTY} if {@literal null}.
	 */
	@Autowired(required = false)
	public void setQueryMappingConfiguration(QueryMappingConfiguration queryMappingConfiguration) {

		Assert.notNull(queryMappingConfiguration, "QueryMappingConfiguration must not be null");

		this.queryMappingConfiguration = queryMappingConfiguration;
	}

	public void setJdbcOperations(NamedParameterJdbcOperations operations) {

		Assert.notNull(operations, "NamedParameterJdbcOperations must not be null");

		this.operations = operations;
	}

	@Autowired(required = false)
	public void setJdbcAggregateTemplate(JdbcAggregateOperations jdbcAggregateOperations) {
		this.jdbcAggregateOperations = jdbcAggregateOperations;
	}

	public void setConverter(JdbcConverter converter) {

		Assert.notNull(converter, "JdbcConverter must not be null");

		this.converter = converter;
	}

	@Override
	public void setBeanFactory(BeanFactory beanFactory) {

		super.setBeanFactory(beanFactory);

		this.beanFactory = beanFactory;
	}

	@Override
	public void afterPropertiesSet() {

		Assert.state(this.mappingContext != null, "MappingContext is required and must not be null");

		if (this.operations == null) {

			Assert.state(beanFactory != null, "If no JdbcOperations are set a BeanFactory must be available");

			this.operations = beanFactory.getBean(NamedParameterJdbcOperations.class);
		}

		if (this.dialect == null) {
			this.dialect = this.beanFactory.getBeanProvider(Dialect.class)
					.getIfAvailable(() -> DialectResolver.getDialect(this.operations.getJdbcOperations()));
		}

		if (this.conversions == null) {
			this.conversions = this.beanFactory.getBeanProvider(JdbcCustomConversions.class).getIfAvailable(() -> {
				SimpleTypeHolder simpleTypeHolder = dialect.simpleTypes().isEmpty()
						? JdbcSimpleTypes.HOLDER
						: new SimpleTypeHolder(dialect.simpleTypes(), JdbcSimpleTypes.HOLDER);
				List<Object> converters = new ArrayList<>();
				converters.addAll(dialect.getConverters());
				converters.addAll(JdbcCustomConversions.storeConverters());
				return new JdbcCustomConversions(CustomConversions.StoreConversions.of(simpleTypeHolder, converters),
						Collections.emptyList());
			});
		}

		if (this.converter == null) {
			this.converter = this.beanFactory.getBeanProvider(JdbcConverter.class).getIfAvailable(() -> {
				RelationResolver relationResolver = ProxyFactory.getProxy(RelationResolver.class, (TargetSource) null);
				JdbcArrayColumns arrayColumns = dialect instanceof JdbcDialect
						? ((JdbcDialect) dialect).getArraySupport()
						: JdbcArrayColumns.DefaultSupport.INSTANCE;
				DefaultJdbcTypeFactory jdbcTypeFactory = new DefaultJdbcTypeFactory(operations.getJdbcOperations(),
						arrayColumns);

				return new BasicJdbcConverter(mappingContext, relationResolver, conversions, jdbcTypeFactory,
						dialect.getIdentifierProcessing());
			});
		}

		if (this.dataAccessStrategy == null) {

			Assert.state(beanFactory != null, "If no DataAccessStrategy is set a BeanFactory must be available");

			this.dataAccessStrategy = this.beanFactory.getBeanProvider(DataAccessStrategy.class) //
					.getIfAvailable(() -> {

						Assert.state(this.dialect != null, "Dialect is required and must not be null");

						SqlGeneratorSource sqlGeneratorSource = new SqlGeneratorSource(this.mappingContext, this.converter,
								this.dialect);
						SqlParametersFactory sqlParametersFactory = new SqlParametersFactory(this.mappingContext, this.converter);
						InsertStrategyFactory insertStrategyFactory = new InsertStrategyFactory(this.operations, this.dialect);

						DataAccessStrategyFactory factory = new DataAccessStrategyFactory(sqlGeneratorSource, this.converter,
								this.operations, sqlParametersFactory, insertStrategyFactory);

						return factory.create();
					});
		}

		if (this.jdbcAggregateOperations == null) {
			this.jdbcAggregateOperations = this.beanFactory.getBeanProvider(JdbcAggregateOperations.class) //
					.getIfAvailable(() -> new JdbcAggregateTemplate(this.publisher, this.mappingContext, this.converter,
							this.dataAccessStrategy));
		}

		if (this.queryMappingConfiguration == null) {
			this.queryMappingConfiguration = QueryMappingConfiguration.EMPTY;
		}

		if (beanFactory != null) {
			entityCallbacks = EntityCallbacks.create(beanFactory);
		}

		super.afterPropertiesSet();
	}
}
