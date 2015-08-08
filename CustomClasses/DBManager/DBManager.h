//
//  DBManager.h
//  TinnitusCoach
//
//  Created by Creospan on 14/03/15.
//  Copyright (c) 2015 Creospan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
@property(nonatomic,strong) NSString *libraryDirectory;
@property(nonatomic,strong) NSString *databaseFileName;

@property (nonatomic, strong) NSMutableArray *arrResults;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-( instancetype )initWithDatabaseFileName: (NSString *)filename;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(void)copyDatabaseIntoLibraryDirectory;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(BOOL)executeQuery:(NSString *)query;
-(BOOL)executeUpdate:(NSString *)query;

-(BOOL)executeQueryResults:(NSString *)query;

@end
