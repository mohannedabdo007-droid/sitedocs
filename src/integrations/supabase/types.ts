export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.18"
  }
  public: {
    Tables: {
      attachments: {
        Row: {
          company_id: string
          created_at: string
          document_id: string
          file_name: string
          id: string
          mime_type: string | null
          project_id: string
          revision_id: string | null
          size_bytes: number | null
          storage_path: string
          uploaded_by: string
        }
        Insert: {
          company_id: string
          created_at?: string
          document_id: string
          file_name: string
          id?: string
          mime_type?: string | null
          project_id: string
          revision_id?: string | null
          size_bytes?: number | null
          storage_path: string
          uploaded_by?: string
        }
        Update: {
          company_id?: string
          created_at?: string
          document_id?: string
          file_name?: string
          id?: string
          mime_type?: string | null
          project_id?: string
          revision_id?: string | null
          size_bytes?: number | null
          storage_path?: string
          uploaded_by?: string
        }
        Relationships: [
          {
            foreignKeyName: "attachments_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attachments_document_id_fkey"
            columns: ["document_id"]
            isOneToOne: false
            referencedRelation: "documents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attachments_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "attachments_revision_id_fkey"
            columns: ["revision_id"]
            isOneToOne: false
            referencedRelation: "document_revisions"
            referencedColumns: ["id"]
          },
        ]
      }
      audit_log: {
        Row: {
          action: string
          actor_id: string | null
          changes: Json
          company_id: string | null
          created_at: string
          document_id: string | null
          entity_id: string | null
          entity_type: string
          id: string
          project_id: string | null
        }
        Insert: {
          action: string
          actor_id?: string | null
          changes?: Json
          company_id?: string | null
          created_at?: string
          document_id?: string | null
          entity_id?: string | null
          entity_type: string
          id?: string
          project_id?: string | null
        }
        Update: {
          action?: string
          actor_id?: string | null
          changes?: Json
          company_id?: string | null
          created_at?: string
          document_id?: string | null
          entity_id?: string | null
          entity_type?: string
          id?: string
          project_id?: string | null
        }
        Relationships: []
      }
      comments: {
        Row: {
          author_id: string
          author_party: Database["public"]["Enums"]["project_party"]
          body: string
          company_id: string
          created_at: string
          document_id: string
          id: string
          project_id: string
          revision_id: string | null
          visibility: Database["public"]["Enums"]["comment_visibility"]
        }
        Insert: {
          author_id?: string
          author_party: Database["public"]["Enums"]["project_party"]
          body: string
          company_id: string
          created_at?: string
          document_id: string
          id?: string
          project_id: string
          revision_id?: string | null
          visibility?: Database["public"]["Enums"]["comment_visibility"]
        }
        Update: {
          author_id?: string
          author_party?: Database["public"]["Enums"]["project_party"]
          body?: string
          company_id?: string
          created_at?: string
          document_id?: string
          id?: string
          project_id?: string
          revision_id?: string | null
          visibility?: Database["public"]["Enums"]["comment_visibility"]
        }
        Relationships: [
          {
            foreignKeyName: "comments_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "comments_document_id_fkey"
            columns: ["document_id"]
            isOneToOne: false
            referencedRelation: "documents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "comments_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "comments_revision_id_fkey"
            columns: ["revision_id"]
            isOneToOne: false
            referencedRelation: "document_revisions"
            referencedColumns: ["id"]
          },
        ]
      }
      companies: {
        Row: {
          code: string
          created_at: string
          created_by: string
          id: string
          name: string
          name_ar: string | null
          updated_at: string
        }
        Insert: {
          code: string
          created_at?: string
          created_by: string
          id?: string
          name: string
          name_ar?: string | null
          updated_at?: string
        }
        Update: {
          code?: string
          created_at?: string
          created_by?: string
          id?: string
          name?: string
          name_ar?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      company_members: {
        Row: {
          company_id: string
          created_at: string
          id: string
          role: Database["public"]["Enums"]["company_role"]
          user_id: string
        }
        Insert: {
          company_id: string
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["company_role"]
          user_id: string
        }
        Update: {
          company_id?: string
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["company_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "company_members_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      disciplines: {
        Row: {
          code: string
          id: string
          name_ar: string
          name_en: string
          sort: number
        }
        Insert: {
          code: string
          id?: string
          name_ar: string
          name_en: string
          sort?: number
        }
        Update: {
          code?: string
          id?: string
          name_ar?: string
          name_en?: string
          sort?: number
        }
        Relationships: []
      }
      document_reviews: {
        Row: {
          action: string
          actor_id: string
          company_id: string
          created_at: string
          document_id: string
          from_status: Database["public"]["Enums"]["doc_lifecycle"] | null
          id: string
          notes: string | null
          party: Database["public"]["Enums"]["project_party"] | null
          project_id: string
          response_code: string | null
          revision_id: string | null
          step: number
          to_status: Database["public"]["Enums"]["doc_lifecycle"]
        }
        Insert: {
          action: string
          actor_id: string
          company_id: string
          created_at?: string
          document_id: string
          from_status?: Database["public"]["Enums"]["doc_lifecycle"] | null
          id?: string
          notes?: string | null
          party?: Database["public"]["Enums"]["project_party"] | null
          project_id: string
          response_code?: string | null
          revision_id?: string | null
          step: number
          to_status: Database["public"]["Enums"]["doc_lifecycle"]
        }
        Update: {
          action?: string
          actor_id?: string
          company_id?: string
          created_at?: string
          document_id?: string
          from_status?: Database["public"]["Enums"]["doc_lifecycle"] | null
          id?: string
          notes?: string | null
          party?: Database["public"]["Enums"]["project_party"] | null
          project_id?: string
          response_code?: string | null
          revision_id?: string | null
          step?: number
          to_status?: Database["public"]["Enums"]["doc_lifecycle"]
        }
        Relationships: [
          {
            foreignKeyName: "document_reviews_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "document_reviews_document_id_fkey"
            columns: ["document_id"]
            isOneToOne: false
            referencedRelation: "documents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "document_reviews_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "document_reviews_revision_id_fkey"
            columns: ["revision_id"]
            isOneToOne: false
            referencedRelation: "document_revisions"
            referencedColumns: ["id"]
          },
        ]
      }
      document_revisions: {
        Row: {
          change_note: string | null
          company_id: string
          created_at: string
          created_by: string
          document_id: string
          id: string
          project_id: string
          responded_at: string | null
          response_by: string | null
          response_code: string | null
          response_notes: string | null
          rev_index: number
          rev_label: string
          source: string
          submitted_at: string | null
        }
        Insert: {
          change_note?: string | null
          company_id: string
          created_at?: string
          created_by?: string
          document_id: string
          id?: string
          project_id: string
          responded_at?: string | null
          response_by?: string | null
          response_code?: string | null
          response_notes?: string | null
          rev_index: number
          rev_label: string
          source?: string
          submitted_at?: string | null
        }
        Update: {
          change_note?: string | null
          company_id?: string
          created_at?: string
          created_by?: string
          document_id?: string
          id?: string
          project_id?: string
          responded_at?: string | null
          response_by?: string | null
          response_code?: string | null
          response_notes?: string | null
          rev_index?: number
          rev_label?: string
          source?: string
          submitted_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "document_revisions_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "document_revisions_document_id_fkey"
            columns: ["document_id"]
            isOneToOne: false
            referencedRelation: "documents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "document_revisions_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      document_types: {
        Row: {
          category: string
          code: string
          has_direction: boolean
          id: string
          name_ar: string
          name_en: string
          requires_review: boolean
          sort: number
          uses_response_codes: boolean
        }
        Insert: {
          category: string
          code: string
          has_direction?: boolean
          id?: string
          name_ar: string
          name_en: string
          requires_review?: boolean
          sort?: number
          uses_response_codes?: boolean
        }
        Update: {
          category?: string
          code?: string
          has_direction?: boolean
          id?: string
          name_ar?: string
          name_en?: string
          requires_review?: boolean
          sort?: number
          uses_response_codes?: boolean
        }
        Relationships: []
      }
      documents: {
        Row: {
          closed_at: string | null
          company_id: string
          created_at: string
          created_by: string
          current_response_code: string | null
          current_rev_index: number
          current_rev_label: string
          current_revision_id: string | null
          current_step: number
          description: string | null
          direction: string | null
          discipline_id: string | null
          doc_number: string
          document_type_id: string
          due_date: string | null
          from_party: string | null
          id: string
          import_batch_id: string | null
          last_response_at: string | null
          legacy_ref: string | null
          location: string | null
          metadata: Json
          originator_party: Database["public"]["Enums"]["project_party"]
          project_id: string
          requires_review: boolean
          review_days: number
          source: string
          status: Database["public"]["Enums"]["doc_lifecycle"]
          submitted_at: string | null
          title: string
          to_party: string | null
          updated_at: string
          uses_response_codes: boolean
          workflow_steps: Database["public"]["Enums"]["project_party"][]
        }
        Insert: {
          closed_at?: string | null
          company_id: string
          created_at?: string
          created_by?: string
          current_response_code?: string | null
          current_rev_index?: number
          current_rev_label?: string
          current_revision_id?: string | null
          current_step?: number
          description?: string | null
          direction?: string | null
          discipline_id?: string | null
          doc_number: string
          document_type_id: string
          due_date?: string | null
          from_party?: string | null
          id?: string
          import_batch_id?: string | null
          last_response_at?: string | null
          legacy_ref?: string | null
          location?: string | null
          metadata?: Json
          originator_party?: Database["public"]["Enums"]["project_party"]
          project_id: string
          requires_review?: boolean
          review_days?: number
          source?: string
          status?: Database["public"]["Enums"]["doc_lifecycle"]
          submitted_at?: string | null
          title: string
          to_party?: string | null
          updated_at?: string
          uses_response_codes?: boolean
          workflow_steps?: Database["public"]["Enums"]["project_party"][]
        }
        Update: {
          closed_at?: string | null
          company_id?: string
          created_at?: string
          created_by?: string
          current_response_code?: string | null
          current_rev_index?: number
          current_rev_label?: string
          current_revision_id?: string | null
          current_step?: number
          description?: string | null
          direction?: string | null
          discipline_id?: string | null
          doc_number?: string
          document_type_id?: string
          due_date?: string | null
          from_party?: string | null
          id?: string
          import_batch_id?: string | null
          last_response_at?: string | null
          legacy_ref?: string | null
          location?: string | null
          metadata?: Json
          originator_party?: Database["public"]["Enums"]["project_party"]
          project_id?: string
          requires_review?: boolean
          review_days?: number
          source?: string
          status?: Database["public"]["Enums"]["doc_lifecycle"]
          submitted_at?: string | null
          title?: string
          to_party?: string | null
          updated_at?: string
          uses_response_codes?: boolean
          workflow_steps?: Database["public"]["Enums"]["project_party"][]
        }
        Relationships: [
          {
            foreignKeyName: "documents_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "documents_current_revision_fk"
            columns: ["current_revision_id"]
            isOneToOne: false
            referencedRelation: "document_revisions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "documents_discipline_id_fkey"
            columns: ["discipline_id"]
            isOneToOne: false
            referencedRelation: "disciplines"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "documents_document_type_id_fkey"
            columns: ["document_type_id"]
            isOneToOne: false
            referencedRelation: "document_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "documents_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      import_batches: {
        Row: {
          column_mapping: Json
          company_id: string
          created_at: string
          created_by: string
          document_type_id: string | null
          file_name: string
          headers: Json
          id: string
          project_id: string
          sheet_name: string
          stats: Json
          status: string
          total_rows: number
          updated_at: string
          value_mapping: Json
        }
        Insert: {
          column_mapping?: Json
          company_id: string
          created_at?: string
          created_by?: string
          document_type_id?: string | null
          file_name: string
          headers?: Json
          id?: string
          project_id: string
          sheet_name: string
          stats?: Json
          status?: string
          total_rows?: number
          updated_at?: string
          value_mapping?: Json
        }
        Update: {
          column_mapping?: Json
          company_id?: string
          created_at?: string
          created_by?: string
          document_type_id?: string | null
          file_name?: string
          headers?: Json
          id?: string
          project_id?: string
          sheet_name?: string
          stats?: Json
          status?: string
          total_rows?: number
          updated_at?: string
          value_mapping?: Json
        }
        Relationships: [
          {
            foreignKeyName: "import_batches_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "import_batches_document_type_id_fkey"
            columns: ["document_type_id"]
            isOneToOne: false
            referencedRelation: "document_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "import_batches_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      import_rows: {
        Row: {
          batch_id: string
          commit_status: string | null
          committed_at: string | null
          committed_document_id: string | null
          company_id: string
          decision: string
          id: string
          mapped: Json | null
          messages: Json
          project_id: string
          raw: Json
          row_number: number
          validation_status: string
        }
        Insert: {
          batch_id: string
          commit_status?: string | null
          committed_at?: string | null
          committed_document_id?: string | null
          company_id: string
          decision?: string
          id?: string
          mapped?: Json | null
          messages?: Json
          project_id: string
          raw: Json
          row_number: number
          validation_status?: string
        }
        Update: {
          batch_id?: string
          commit_status?: string | null
          committed_at?: string | null
          committed_document_id?: string | null
          company_id?: string
          decision?: string
          id?: string
          mapped?: Json | null
          messages?: Json
          project_id?: string
          raw?: Json
          row_number?: number
          validation_status?: string
        }
        Relationships: [
          {
            foreignKeyName: "import_rows_batch_id_fkey"
            columns: ["batch_id"]
            isOneToOne: false
            referencedRelation: "import_batches"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "import_rows_committed_document_id_fkey"
            columns: ["committed_document_id"]
            isOneToOne: false
            referencedRelation: "documents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "import_rows_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "import_rows_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      integration_connections: {
        Row: {
          company_id: string
          config: Json
          created_at: string
          id: string
          project_id: string | null
          provider: string
          status: string
        }
        Insert: {
          company_id: string
          config?: Json
          created_at?: string
          id?: string
          project_id?: string | null
          provider: string
          status?: string
        }
        Update: {
          company_id?: string
          config?: Json
          created_at?: string
          id?: string
          project_id?: string | null
          provider?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "integration_connections_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "integration_connections_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      numbering_schemes: {
        Row: {
          company_id: string
          discipline_id: string | null
          document_type_id: string
          id: string
          next_seq: number
          pattern: string
          project_id: string
          updated_at: string
        }
        Insert: {
          company_id: string
          discipline_id?: string | null
          document_type_id: string
          id?: string
          next_seq?: number
          pattern: string
          project_id: string
          updated_at?: string
        }
        Update: {
          company_id?: string
          discipline_id?: string | null
          document_type_id?: string
          id?: string
          next_seq?: number
          pattern?: string
          project_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "numbering_schemes_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "numbering_schemes_discipline_id_fkey"
            columns: ["discipline_id"]
            isOneToOne: false
            referencedRelation: "disciplines"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "numbering_schemes_document_type_id_fkey"
            columns: ["document_type_id"]
            isOneToOne: false
            referencedRelation: "document_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "numbering_schemes_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      ocr_jobs: {
        Row: {
          attachment_id: string
          company_id: string
          created_at: string
          extracted: Json | null
          id: string
          project_id: string
          reviewed_at: string | null
          reviewed_by: string | null
          status: string
        }
        Insert: {
          attachment_id: string
          company_id: string
          created_at?: string
          extracted?: Json | null
          id?: string
          project_id: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: string
        }
        Update: {
          attachment_id?: string
          company_id?: string
          created_at?: string
          extracted?: Json | null
          id?: string
          project_id?: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "ocr_jobs_attachment_id_fkey"
            columns: ["attachment_id"]
            isOneToOne: false
            referencedRelation: "attachments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ocr_jobs_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "ocr_jobs_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          created_at: string
          email: string | null
          full_name: string | null
          id: string
          locale: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          email?: string | null
          full_name?: string | null
          id: string
          locale?: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          email?: string | null
          full_name?: string | null
          id?: string
          locale?: string
          updated_at?: string
        }
        Relationships: []
      }
      project_members: {
        Row: {
          company_id: string
          created_at: string
          id: string
          organization: string | null
          party: Database["public"]["Enums"]["project_party"]
          project_id: string
          is_project_manager: boolean
          role: Database["public"]["Enums"]["project_role"]
          user_id: string
        }
        Insert: {
          company_id: string
          created_at?: string
          id?: string
          organization?: string | null
          party: Database["public"]["Enums"]["project_party"]
          project_id: string
          is_project_manager?: boolean
          role?: Database["public"]["Enums"]["project_role"]
          user_id: string
        }
        Update: {
          company_id?: string
          created_at?: string
          id?: string
          organization?: string | null
          party?: Database["public"]["Enums"]["project_party"]
          project_id?: string
          is_project_manager?: boolean
          role?: Database["public"]["Enums"]["project_role"]
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "project_members_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "project_members_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      project_membership_policies: {
        Row: {
          project_id: string
          external_company_acceptance_required: boolean
          updated_by: string | null
          updated_at: string
          change_reason: string | null
        }
        Insert: {
          project_id: string
          external_company_acceptance_required?: boolean
          updated_by?: string | null
          updated_at?: string
          change_reason?: string | null
        }
        Update: {
          project_id?: string
          external_company_acceptance_required?: boolean
          updated_by?: string | null
          updated_at?: string
          change_reason?: string | null
        }
        Relationships: []
      }
      project_company_invitations: {
        Row: {
          id: string
          project_id: string
          project_company_id: string
          invited_company_id: string
          party: Database["public"]["Enums"]["project_party"]
          status: string
          invited_by: string
          accepted_by: string | null
          accepted_at: string | null
          responded_at: string | null
          expires_at: string
          created_at: string
        }
        Insert: {
          id?: string
          project_id: string
          project_company_id: string
          invited_company_id: string
          party: Database["public"]["Enums"]["project_party"]
          status?: string
          invited_by: string
          accepted_by?: string | null
          accepted_at?: string | null
          responded_at?: string | null
          expires_at?: string
          created_at?: string
        }
        Update: {
          id?: string
          project_id?: string
          project_company_id?: string
          invited_company_id?: string
          party?: Database["public"]["Enums"]["project_party"]
          status?: string
          invited_by?: string
          accepted_by?: string | null
          accepted_at?: string | null
          responded_at?: string | null
          expires_at?: string
          created_at?: string
        }
        Relationships: []
      }
      project_party_companies: {
        Row: {
          id: string
          project_id: string
          project_company_id: string
          participant_company_id: string
          party: Database["public"]["Enums"]["project_party"]
          invitation_id: string | null
          linked_by: string
          linked_at: string
        }
        Insert: {
          id?: string
          project_id: string
          project_company_id: string
          participant_company_id: string
          party: Database["public"]["Enums"]["project_party"]
          invitation_id?: string | null
          linked_by: string
          linked_at?: string
        }
        Update: {
          id?: string
          project_id?: string
          project_company_id?: string
          participant_company_id?: string
          party?: Database["public"]["Enums"]["project_party"]
          invitation_id?: string | null
          linked_by?: string
          linked_at?: string
        }
        Relationships: []
      }
      project_membership_events: {
        Row: {
          id: string
          project_id: string
          project_company_id: string
          actor_user_id: string
          action: string
          participant_company_id: string | null
          party: Database["public"]["Enums"]["project_party"] | null
          member_user_id: string | null
          invitation_id: string | null
          policy_before: boolean | null
          policy_after: boolean | null
          reason: string | null
          created_at: string
        }
        Insert: {
          id?: string
          project_id: string
          project_company_id: string
          actor_user_id: string
          action: string
          participant_company_id?: string | null
          party?: Database["public"]["Enums"]["project_party"] | null
          member_user_id?: string | null
          invitation_id?: string | null
          policy_before?: boolean | null
          policy_after?: boolean | null
          reason?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          project_id?: string
          project_company_id?: string
          actor_user_id?: string
          action?: string
          participant_company_id?: string | null
          party?: Database["public"]["Enums"]["project_party"] | null
          member_user_id?: string | null
          invitation_id?: string | null
          policy_before?: boolean | null
          policy_after?: boolean | null
          reason?: string | null
          created_at?: string
        }
        Relationships: []
      }
      project_response_codes: {
        Row: {
          active: boolean
          code: string
          company_id: string
          id: string
          label_ar: string
          label_en: string
          outcome: Database["public"]["Enums"]["response_outcome"]
          project_id: string
          sort: number
        }
        Insert: {
          active?: boolean
          code: string
          company_id: string
          id?: string
          label_ar: string
          label_en: string
          outcome: Database["public"]["Enums"]["response_outcome"]
          project_id: string
          sort?: number
        }
        Update: {
          active?: boolean
          code?: string
          company_id?: string
          id?: string
          label_ar?: string
          label_en?: string
          outcome?: Database["public"]["Enums"]["response_outcome"]
          project_id?: string
          sort?: number
        }
        Relationships: [
          {
            foreignKeyName: "project_response_codes_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "project_response_codes_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      project_workflows: {
        Row: {
          company_id: string
          document_type_id: string | null
          id: string
          project_id: string
          requires_review: boolean | null
          review_days: number
          steps: Database["public"]["Enums"]["project_party"][]
          updated_at: string
          uses_response_codes: boolean | null
        }
        Insert: {
          company_id: string
          document_type_id?: string | null
          id?: string
          project_id: string
          requires_review?: boolean | null
          review_days?: number
          steps: Database["public"]["Enums"]["project_party"][]
          updated_at?: string
          uses_response_codes?: boolean | null
        }
        Update: {
          company_id?: string
          document_type_id?: string | null
          id?: string
          project_id?: string
          requires_review?: boolean | null
          review_days?: number
          steps?: Database["public"]["Enums"]["project_party"][]
          updated_at?: string
          uses_response_codes?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "project_workflows_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "project_workflows_document_type_id_fkey"
            columns: ["document_type_id"]
            isOneToOne: false
            referencedRelation: "document_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "project_workflows_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      projects: {
        Row: {
          client_name: string | null
          code: string
          company_id: string
          created_at: string
          created_by: string
          id: string
          location: string | null
          name: string
          name_ar: string | null
          start_date: string | null
          status: string
          updated_at: string
        }
        Insert: {
          client_name?: string | null
          code: string
          company_id: string
          created_at?: string
          created_by: string
          id?: string
          location?: string | null
          name: string
          name_ar?: string | null
          start_date?: string | null
          status?: string
          updated_at?: string
        }
        Update: {
          client_name?: string | null
          code?: string
          company_id?: string
          created_at?: string
          created_by?: string
          id?: string
          location?: string | null
          name?: string
          name_ar?: string | null
          start_date?: string | null
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "projects_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
        ]
      }
      sync_jobs: {
        Row: {
          attempts: number
          company_id: string
          conflict: Json | null
          connection_id: string | null
          created_at: string
          direction: string
          entity_id: string | null
          entity_type: string
          id: string
          last_error: string | null
          max_attempts: number
          next_retry_at: string | null
          project_id: string | null
          status: string
          updated_at: string
        }
        Insert: {
          attempts?: number
          company_id: string
          conflict?: Json | null
          connection_id?: string | null
          created_at?: string
          direction: string
          entity_id?: string | null
          entity_type: string
          id?: string
          last_error?: string | null
          max_attempts?: number
          next_retry_at?: string | null
          project_id?: string | null
          status?: string
          updated_at?: string
        }
        Update: {
          attempts?: number
          company_id?: string
          conflict?: Json | null
          connection_id?: string | null
          created_at?: string
          direction?: string
          entity_id?: string | null
          entity_type?: string
          id?: string
          last_error?: string | null
          max_attempts?: number
          next_retry_at?: string | null
          project_id?: string | null
          status?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sync_jobs_company_id_fkey"
            columns: ["company_id"]
            isOneToOne: false
            referencedRelation: "companies"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sync_jobs_connection_id_fkey"
            columns: ["connection_id"]
            isOneToOne: false
            referencedRelation: "integration_connections"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "sync_jobs_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      search_companies_for_project_invitation: {
        Args: { _project: string; _query: string }
        Returns: {
          code: string
          id: string
          name: string
          name_ar: string | null
        }[]
      }
      list_project_company_invitations: {
        Args: { _project?: string }
        Returns: {
          can_respond: boolean
          can_revoke: boolean
          created_at: string
          direction: string
          expires_at: string
          id: string
          invited_company_name: string
          owner_company_name: string
          party: Database["public"]["Enums"]["project_party"]
          project_code: string
          project_id: string
          project_name: string
          status: string
        }[]
      }
      add_company_member: {
        Args: {
          _company: string
          _email: string
          _role: Database["public"]["Enums"]["company_role"]
        }
        Returns: string
      }
      accept_project_company_invitation: {
        Args: { _invitation: string }
        Returns: string
      }
      add_project_member: {
        Args: {
          _email: string
          _member_company?: string
          _organization?: string
          _party: Database["public"]["Enums"]["project_party"]
          _project: string
          _role: Database["public"]["Enums"]["project_role"]
        }
        Returns: string
      }
      invite_project_company: {
        Args: {
          _expires_at?: string
          _invited_company: string
          _party: Database["public"]["Enums"]["project_party"]
          _project: string
        }
        Returns: string
      }
      reject_project_company_invitation: {
        Args: { _invitation: string; _reason?: string }
        Returns: boolean
      }
      revoke_project_company_invitation: {
        Args: { _invitation: string; _reason: string }
        Returns: boolean
      }
      set_project_membership_policy: {
        Args: {
          _external_company_acceptance_required: boolean
          _project: string
          _reason: string
        }
        Returns: boolean
      }
      can_comment: { Args: { _project: string }; Returns: boolean }
      can_edit_documents: { Args: { _project: string }; Returns: boolean }
      can_manage_project: { Args: { _project: string }; Returns: boolean }
      commit_import_rows: {
        Args: { _batch: string; _limit?: number }
        Returns: Json
      }
      create_company: {
        Args: { _code: string; _name: string; _name_ar?: string }
        Returns: string
      }
      create_project: {
        Args: {
          _client?: string
          _code: string
          _company: string
          _location?: string
          _name: string
          _name_ar?: string
          _party: Database["public"]["Enums"]["project_party"]
        }
        Returns: string
      }
      document_kpi_matrix: {
        Args: { _project?: string }
        Returns: {
          aging_0_7: number
          aging_15_30: number
          aging_31p: number
          aging_8_14: number
          discipline_code: string
          docs: number
          max_pending: number
          overdue: number
          pending_days_sum: number
          pending_n: number
          project_id: string
          response_code: string
          resubmitted: number
          revisions_total: number
          status: Database["public"]["Enums"]["doc_lifecycle"]
          type_code: string
        }[]
      }
      existing_revisions_for_numbers: {
        Args: { _numbers: string[]; _project: string }
        Returns: {
          doc_number: string
          document_type_code: string
          rev_index: number
          rev_label: string
        }[]
      }
      format_doc_number: {
        Args: {
          _at?: string
          _disc: string
          _pattern: string
          _project: string
          _seq: number
          _type: string
        }
        Returns: string
      }
      is_company_admin: { Args: { _company: string }; Returns: boolean }
      is_company_member: { Args: { _company: string }; Returns: boolean }
      is_project_member: { Args: { _project: string }; Returns: boolean }
      preview_document_number: {
        Args: { _disc: string; _project: string; _type: string }
        Returns: string
      }
      project_party_of: {
        Args: { _project: string }
        Returns: Database["public"]["Enums"]["project_party"]
      }
      project_role_of: {
        Args: { _project: string }
        Returns: Database["public"]["Enums"]["project_role"]
      }
      resolve_numbering_scheme: {
        Args: { _disc: string; _project: string; _type: string }
        Returns: {
          company_id: string
          discipline_id: string | null
          document_type_id: string
          id: string
          next_seq: number
          pattern: string
          project_id: string
          updated_at: string
        }
        SetofOptions: {
          from: "*"
          to: "numbering_schemes"
          isOneToOne: true
          isSetofReturn: false
        }
      }
      save_import_validation: {
        Args: { _batch: string; _rows: Json }
        Returns: number
      }
      shares_scope_with: { Args: { _other: string }; Returns: boolean }
      storage_project_id: { Args: { _name: string }; Returns: string }
      transition_document: {
        Args: {
          _action: string
          _doc: string
          _notes?: string
          _response_code?: string
        }
        Returns: {
          closed_at: string | null
          company_id: string
          created_at: string
          created_by: string
          current_response_code: string | null
          current_rev_index: number
          current_rev_label: string
          current_revision_id: string | null
          current_step: number
          description: string | null
          direction: string | null
          discipline_id: string | null
          doc_number: string
          document_type_id: string
          due_date: string | null
          from_party: string | null
          id: string
          import_batch_id: string | null
          last_response_at: string | null
          legacy_ref: string | null
          location: string | null
          metadata: Json
          originator_party: Database["public"]["Enums"]["project_party"]
          project_id: string
          requires_review: boolean
          review_days: number
          source: string
          status: Database["public"]["Enums"]["doc_lifecycle"]
          submitted_at: string | null
          title: string
          to_party: string | null
          updated_at: string
          uses_response_codes: boolean
          workflow_steps: Database["public"]["Enums"]["project_party"][]
        }
        SetofOptions: {
          from: "*"
          to: "documents"
          isOneToOne: true
          isSetofReturn: false
        }
      }
    }
    Enums: {
      comment_visibility: "internal" | "external"
      company_role: "owner" | "admin" | "member"
      doc_lifecycle:
        | "draft"
        | "submitted"
        | "under_review"
        | "returned"
        | "approved"
        | "closed"
      project_party: "contractor" | "consultant" | "owner" | "pmc"
      project_role: "admin" | "controller" | "reviewer" | "viewer"
      response_outcome: "proceed" | "return" | "close"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      comment_visibility: ["internal", "external"],
      company_role: ["owner", "admin", "member"],
      doc_lifecycle: [
        "draft",
        "submitted",
        "under_review",
        "returned",
        "approved",
        "closed",
      ],
      project_party: ["contractor", "consultant", "owner", "pmc"],
      project_role: ["admin", "controller", "reviewer", "viewer"],
      response_outcome: ["proceed", "return", "close"],
    },
  },
} as const