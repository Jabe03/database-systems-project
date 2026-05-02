type TableData = {
    columns: string[];
    rows: unknown[][];
};
type RenderTableConfig = {
    tableName: string;
    primaryKey: string;
    containerId: string;
    onEdit: (pkValue: unknown, columns: string[], row: unknown[]) => void | Promise<void>;
    onDelete: (pkValue: unknown) => void | Promise<void>;
};
export declare function makeRequest(input: string): Promise<unknown>;
export declare function renderTable(data: TableData, config: RenderTableConfig): void;
export {};
//# sourceMappingURL=database_page.d.ts.map